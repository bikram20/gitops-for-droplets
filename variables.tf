variable "ssh_key" {
  type = string
  default = "bg-mac"
}

variable "image" {
  type = string
}

variable "droplet_name" {
  type = string
}

variable "region" {
  type = string
}

variable "size" {
  type = string
}

variable "create_volume" {
  type = bool
  default = false
}

variable "volume_name" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "user_name" {
  type    = string
  default = "ubuntu"
}

variable "ssh_pvt_key" {
  type = string
}

variable "domain_name" {
  description = "Domain name to map to the droplet. Make sure that the domain name points to DigitalOcean name servers, and has no A records associated."
}

variable "subdomain_names" {
  description = "List of subdomain names"
  type        = list(string)
  default     = []
}

variable "dynamic_subdomain_setup" {
  type = bool
  default = false
}


variable "firewall_name" {
  description = "Name of the firewall"
}

variable "inbound_rules" {
  description = "List of inbound firewall rules"
  type        = list(object({
    protocol = string
    port_range    = string
    sources  = list(string)
  }))
  default     = []
}

variable "outbound_rules" {
  description = "List of outbound firewall rules"
  type        = list(object({
    protocol = string
    port_range    = string
    destinations = list(string)
  }))
  default     = []
}
