output "ipv4_addresses" {
  description = "Container IPv4 addresses"
  value       = [for iface in var.interfaces : iface.ip]
}

output "container_id" {
  description = "Proxmox container ID"
  value       = proxmox_virtual_environment_container.this.id
}
