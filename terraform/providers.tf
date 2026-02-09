terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"  # Official community provider
    }
  }
}

provider "proxmox" {
    endpoint      = var.proxmox_endpoint 
    api_token = "terraform-prov@pve!token00=${var.proxmox_api_key}"
    insecure = true
}
