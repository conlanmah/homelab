variable "PROXMOX_API_KEY" {
    type            = string
    sensitive       = true
}

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"  # Official community provider
    }
  }
}

provider "proxmox" {
    pm_api_url      = "https://192.168.200.1:8006/api2/json"
    pm_user         = "cmah"
    pm_password     = var.PROXMOX_API_KEY 
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "terra-test" {
    name            = "terra-test"
    target_node     = "nord"
    clone           = "linuxmint-22.1-cinnamon-64bit.iso"
    storage         = storage.disks 
    cores           = 2
    memory          = 2048
}
