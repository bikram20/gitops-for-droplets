output "ipv4_address" {
  value       = digitalocean_droplet.droplet.ipv4_address
  description = "The public IPv4 address of the Droplet"
}
