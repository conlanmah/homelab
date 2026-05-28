output "ipv4_address" {
  description = "Container IPv4 address"
  value       = var.ipv4_address
}

output "container_id" {
  description = "Proxmox container ID"
  value       = proxmox_virtual_environment_container.this.id
}
