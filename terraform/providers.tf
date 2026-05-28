terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "terraform-prov@pve!token00=${var.proxmox_api_token}"
  insecure  = true
}
