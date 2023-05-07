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

variable "ssh_key_id" {
  type = string
}
