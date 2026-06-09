
locals {
  # Merge defaults with per-host overrides
  containers = {
    for name, host in var.nix_containers : name => {
      hostname = name
      interfaces = [
        for i, iface in host.interfaces : {
          name   = coalesce(iface.name, "eth${i}")
          bridge = coalesce(iface.bridge, var.container_defaults.default_bridge)
          ip     = iface.ip
          # Only the primary interface (index 0) defaults to ipv4_gateway; secondary NICs get null unless explicit
          gateway = i == 0 ? coalesce(iface.gateway, var.container_defaults.ipv4_gateway) : iface.gateway
        }
      ]
      node_name        = coalesce(host.node_name, var.container_defaults.node_name)
      datastore_id     = coalesce(host.datastore_id, var.container_defaults.datastore_id)
      template_file_id = coalesce(host.template_file_id, var.container_defaults.template_file_id)
      ssh_public_keys  = coalesce(host.ssh_public_keys, var.container_defaults.ssh_public_keys)
      user_password    = coalesce(host.user_password, var.container_defaults.user_password)
      cpu_cores        = coalesce(host.cpu_cores, var.container_defaults.cpu_cores)
      memory_mb        = coalesce(host.memory_mb, var.container_defaults.memory_mb)
      disk_size_gb     = coalesce(host.disk_size_gb, var.container_defaults.disk_size_gb)
      tags             = host.tags
    }
  }
}

module "nix_container" {
  for_each = local.containers
  source   = "./modules/nix-ct"

  hostname         = each.value.hostname
  interfaces       = each.value.interfaces
  node_name        = each.value.node_name
  datastore_id     = each.value.datastore_id
  template_file_id = each.value.template_file_id
  ssh_public_keys  = each.value.ssh_public_keys
  user_password    = each.value.user_password
  cpu_cores        = each.value.cpu_cores
  memory_mb        = each.value.memory_mb
  disk_size_gb     = each.value.disk_size_gb
  tags             = each.value.tags
}

# Not importing this cause lack of support for unprivileged containers
# makes this a headache

# module "immich" {
#   source   = "./modules/nix-ct"
  
#   hostname         = "immich-mars"
#   interfaces       = [
#     {
#       name = "eth0" 
#       ip = "192.168.200.102/24", 
#       bridge = "vmbr0", 
#       gateway = "192.168.200.60" 
#     },                                          # vmbr0, default gateway
#     { 
#       name = "eth1"
#       ip = "192.168.150.102/24", 
#       bridge = "vmbr1"
#     },    # vmbr1, explicit gateway
#   ]
#   node_name        = "catpuccin"
#   datastore_id     = "vdisks"
#   template_file_id = "isos:vztmpl/nixos-image-lxc-proxmox-25.05.20250112.2f9e2f8-x86_64-linux.tar.xz"
#   ssh_public_keys  = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"]
#   user_password    = "changeme"
#   cpu_cores        = 4
#   memory_mb        = 8096
#   tags             = ["prod"]
# }
