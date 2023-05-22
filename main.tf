data "digitalocean_ssh_key" "terraform" {
  name = var.ssh_key
}

data "digitalocean_domain" "domain" {
  name = var.domain_name
}

resource "digitalocean_volume" "volume" {
  count = var.create_volume ? 1 : 0

  region      = var.region
  name        = var.volume_name
  size        = var.volume_size
}

resource "digitalocean_droplet" "droplet" {
  image  = var.image
  name   = var.droplet_name
  region = var.region
  size   = var.size
  volume_ids = var.create_volume ? [digitalocean_volume.volume[0].id] : []

  ssh_keys = [data.digitalocean_ssh_key.terraform.id]
}

resource "null_resource" "provisioner" {
  connection {
    host        = digitalocean_droplet.droplet.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.ssh_pvt_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt update",
      "sudo adduser --disabled-password --gecos \"\" ${var.user_name}",
      "sudo usermod -aG sudo ${var.user_name}",
      "sudo rsync --archive --chown=${var.user_name}:${var.user_name} ~/.ssh /home/${var.user_name}",
      "sudo chmod 700 /home/${var.user_name}/.ssh",
      "sudo chmod 600 /home/${var.user_name}/.ssh/authorized_keys",
      "echo \"${var.user_name} ALL=(ALL) NOPASSWD:ALL\" | sudo tee -a /etc/sudoers",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "if [ \"${var.create_volume}\" = \"false\" ]; then exit 0; fi",
      "sudo apt-get install -y xfsprogs", # Install xfsprogs package for XFS filesystem support
      "sudo mkfs.xfs /dev/disk/by-id/scsi-0DO_Volume_${var.volume_name}", # Format the volume with XFS filesystem
      "sudo mkdir /mnt/${var.volume_name}", # Create a mount point directory
      "echo \"/dev/disk/by-id/scsi-0DO_Volume_${var.volume_name} /mnt/${var.volume_name} xfs defaults,nofail 0 0\" | sudo tee -a /etc/fstab", # Add an entry to /etc/fstab to mount the volume at boot
      "sudo mount -a" # Mount all filesystems mentioned in /etc/fstab
    ]
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo ufw disable",
      "sudo systemctl disable ufw",
    ]
  }
}

resource "digitalocean_record" "root_domain_record" {
  count   = data.digitalocean_domain.domain != null ? 1 : 0
  domain  = var.domain_name
  type    = "A"
  name    = "@"
  value   = digitalocean_droplet.droplet.ipv4_address
  ttl     = 1800
  priority = 0

  depends_on = [digitalocean_droplet.droplet]
}

resource "digitalocean_record" "subdomain_records" {
  count    = length(var.subdomain_names)
  domain   = var.domain_name
  type     = "A"
  name     = var.subdomain_names[count.index]
  value    = digitalocean_droplet.droplet.ipv4_address
  ttl      = 1800
  priority = 0

  depends_on = [digitalocean_droplet.droplet]
}

resource "digitalocean_firewall" "firewall" {
  name = var.firewall_name

  depends_on = [digitalocean_droplet.droplet]
  droplet_ids = [digitalocean_droplet.droplet.id]

  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_addresses  = ["0.0.0.0/0"]
  }

  dynamic "inbound_rule" {
    for_each = var.inbound_rules
    content {
      protocol          = inbound_rule.value.protocol
      port_range        = inbound_rule.value.port_range
      source_addresses  = inbound_rule.value.sources
    }
  }

  dynamic "outbound_rule" {
    for_each = var.outbound_rules
    content {
      protocol           = outbound_rule.value.protocol
      port_range         = outbound_rule.value.port_range
      destination_addresses = outbound_rule.value.destinations
    }
  }
}

resource "null_resource" "docker" {
  connection {
    host        = digitalocean_droplet.droplet.ipv4_address
    user        = var.user_name
    type        = "ssh"
    private_key = file(var.ssh_pvt_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.user_name}/wordpress-setup",
      "sleep 5",  # Add a short delay for directory creation
    ]
  }

  provisioner "file" {
    source      = "./wordpress-setup"
    destination = "/home/${var.user_name}/"
  }
  
  # Before running docker compose, sleep for 5 min for domain information to propagate
  provisioner "remote-exec" {
    inline = [
      "cd /home/${var.user_name}/wordpress-setup",
      "sleep 300",
      "sudo docker compose up -d"
    ]
  }

  triggers = {
    always_run = timestamp()
  }
}
