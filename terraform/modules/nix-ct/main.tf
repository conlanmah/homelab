terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.70"
    }
  }
}

resource "proxmox_virtual_environment_container" "this" {
  node_name = var.node_name

  initialization {
    hostname = var.hostname

    dynamic "ip_config" {
      for_each = var.interfaces
      content {
        ipv4 {
          address = ip_config.value.ip
          gateway = ip_config.value.gateway
        }
      }
    }

    user_account {
      keys     = var.ssh_public_keys
      password = var.user_password
    }
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size_gb
  }

  dynamic "network_interface" {
    for_each = var.interfaces
    content {
      name   = network_interface.value.name
      bridge = network_interface.value.bridge
    }
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "nixos"
  }

  features {
    nesting = true
  }

  unprivileged  = true
  start_on_boot = true

  tags = var.tags
}
