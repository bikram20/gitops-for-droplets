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
  default = "test-volume"
}

variable "volume_size" {
  type = number
  default = 10
}

variable "user_name" {
  type    = string
  default = "ubuntu"
}

variable "ssh_pvt_key" {
  type = string
}
