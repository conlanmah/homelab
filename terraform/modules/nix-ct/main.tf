resource "proxmox_virtual_environment_container" "this" {
  node_name    = var.node_name
  unprivileged = var.unprivileged
  tags         = var.tags

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    user_account {
      keys     = var.ssh_public_keys
      password = var.user_password
    }
  }

  cpu {
    architecture = var.cpu_architecture
    cores        = var.cpu_cores
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size_gb
  }

  memory {
    dedicated = var.memory_mb
    swap      = var.swap_mb
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "nixos" # var.os_type
  }

  network_interface {
    name = var.network_interface_name
  }

  features {
    nesting = var.nesting
  }
}
