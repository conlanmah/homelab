terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"  # Official community provider
    }
  }
}

variable "PROXMOX_API_KEY" {
    type            = string
    sensitive       = true
}

provider "proxmox" {
    endpoint      = "https://192.168.200.1:8006/api2/json"
    api_token = "terraform-prov@pve!token00=${var.PROXMOX_API_KEY}"
    insecure = true
}

# resource "proxmo_lxc" "nixos-temp" {
#     ostemplate = ""
# }

resource "proxmox_virtual_environment_container" "nix_ct_test" {
    node_name           = "everforest"
    vm_id               = 201
    unprivileged        = true
    tags                = ["terraform"]

    initialization {
        hostname        = "nix-ct-test"
        ip_config {
            ipv4 {
                address = "dhcp"
            }
        }
    }

    cpu {
        architecture    = "amd64"
        cores           = 2
    }

    disk {
        datastore_id    = "vdisks"
        size            = 32
    }

    memory {
        dedicated       = 4096
        swap            = 0
    }

    operating_system {
        template_file_id = "isos:vztmpl/nixos-image-lxc-proxmox-25.05.20250112.2f9e2f8-x86_64-linux.tar.xz"
        type = "nixos"
    }

    network_interface {
        name            = "eth0"
    }

    features {
        nesting = true
    }
}
