# Proxmox provider configuration
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token (format: user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}

# Global defaults - apply to all containers unless overridden
variable "container_defaults" {
  description = "Default values for all NixOS containers"
  type = object({
    node_name        = string
    datastore_id     = string
    template_file_id = string
    default_bridge   = optional(string, "vmbr0")  # Proxmox bridge name; must exist on target node
    ipv4_gateway     = string
    ssh_public_keys  = list(string)
    user_password    = string
    cpu_cores        = optional(number, 1)
    memory_mb        = optional(number, 3072)
    disk_size_gb     = optional(number, 32)
  })
}

# Per-host configuration - only specify overrides
variable "nix_containers" {
  description = "NixOS containers to create (values override defaults)"
  type = map(object({
    interfaces = list(object({
      name    = optional(string)  # defaults to "eth{index}"
      bridge  = optional(string)  # defaults to container_defaults.default_bridge
      ip      = string            # required; CIDR notation e.g. 192.168.1.10/24
      gateway = optional(string)  # primary interface defaults to ipv4_gateway; secondary defaults to null
    }))
    node_name        = optional(string)
    datastore_id     = optional(string)
    template_file_id = optional(string)
    ssh_public_keys  = optional(list(string))
    user_password    = optional(string)
    cpu_cores        = optional(number)
    memory_mb        = optional(number)
    disk_size_gb     = optional(number)
    tags             = optional(list(string), [])
  }))
  default = {}
}
