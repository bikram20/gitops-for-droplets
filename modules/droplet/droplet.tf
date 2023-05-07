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

  ssh_keys = [
    var.ssh_key_id
  ]
}
