variable "hostname" {
  description = "Container hostname"
  type        = string
}

variable "node_name" {
  description = "Proxmox node to create the container on"
  type        = string
}

variable "interfaces" {
  description = "Network interfaces (name, bridge, ip with CIDR, optional gateway)"
  type = list(object({
    name    = string
    bridge  = string
    ip      = string
    gateway = optional(string)
  }))
}

variable "datastore_id" {
  description = "Datastore ID for container disk"
  type        = string
}

variable "template_file_id" {
  description = "Template file ID for the NixOS container image"
  type        = string
}

variable "ssh_public_keys" {
  description = "SSH public keys for root user"
  type        = list(string)
}

variable "user_password" {
  description = "Password for root user"
  type        = string
  sensitive   = true
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "memory_mb" {
  description = "Memory in MB"
  type        = number
  default     = 3072
}

variable "disk_size_gb" {
  description = "Root disk size in GB"
  type        = number
  default     = 32
}

variable "tags" {
  description = "Tags for the container"
  type        = list(string)
  default     = []
}
