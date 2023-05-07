data "digitalocean_ssh_key" "terraform" {
  name = var.ssh_key
}

module "droplet" {
  source = "../modules/droplet"

  image         = var.image
  droplet_name  = var.droplet_name
  region        = var.region
  size          = var.size
  create_volume = var.create_volume
  volume_name   = var.volume_name
  volume_size   = var.volume_size
  ssh_key_id    = data.digitalocean_ssh_key.terraform.id
}

resource "null_resource" "provisioner" {
  connection {
    host        = module.droplet.ipv4_address
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
}


