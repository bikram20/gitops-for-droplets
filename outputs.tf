output "ipv4_address" {
  value       = digitalocean_droplet.droplet.ipv4_address
  description = "The public IPv4 address of the Droplet"
}

output "domain_mapping" {
  value = data.digitalocean_domain.domain != null ? "Domain mapped successfully" : "Domain not configured"
}

output "firewall_id" {
  value = digitalocean_firewall.firewall.id
}
