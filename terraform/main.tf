# terraform {
#   required_providers {
#     proxmox = {
#       source  = "bpg/proxmox"
#     }
#   }
# }
# 
# provider "proxmox" {
#   endpoint  = var.proxmox_api_url
#   api_token = "terraform-prov@pve!token00=${var.proxmox_api_token}"
#   insecure  = true
# }

locals {
  # Merge defaults with per-host overrides
  containers = {
    for name, host in var.nix_containers : name => {
      hostname         = name
      ipv4_address     = host.ipv4_address
      node_name        = coalesce(host.node_name, var.container_defaults.node_name)
      datastore_id     = coalesce(host.datastore_id, var.container_defaults.datastore_id)
      template_file_id = coalesce(host.template_file_id, var.container_defaults.template_file_id)
      ipv4_gateway     = coalesce(host.ipv4_gateway, var.container_defaults.ipv4_gateway)
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
  node_name        = each.value.node_name
  ipv4_address     = each.value.ipv4_address
  ipv4_gateway     = each.value.ipv4_gateway
  datastore_id     = each.value.datastore_id
  template_file_id = each.value.template_file_id
  ssh_public_keys  = each.value.ssh_public_keys
  user_password    = each.value.user_password
  cpu_cores        = each.value.cpu_cores
  memory_mb        = each.value.memory_mb
  disk_size_gb     = each.value.disk_size_gb
  tags             = each.value.tags
}
