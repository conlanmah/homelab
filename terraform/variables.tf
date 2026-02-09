variable "proxmox_api_key" {
    type            = string
    sensitive       = true
}

variable "ipv4_gateway" {
    type            = string
}

variable "proxmox_endpoint" {
    type            = string
}

variable "nix_ct_temp" {
    description = "File name of the container template."
    type            = string
}
