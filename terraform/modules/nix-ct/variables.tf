###########################################
###### REQUIRED ############################
##############################################

variable "node_name" {
  description = "Proxmox node name to create the container on."
  type        = string
}

variable "hostname" {
  description = "Container hostname."
  type        = string
}
variable "ipv4_address" {
  description = "IPv4 address in CIDR notation (e.g. 192.168.1.10/24)."
  type        = string
  validation {
    condition     = can(cidrnetmask(var.ipv4_address)) || var.ipv4_address== "dhcp"
    error_message = "Must be CIDR like '192.168.1.100/24' or 'dhcp'."
  }
}
variable "ipv4_gateway" {
  description = "IPv4 gateway address."
  type        = string
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ipv4_gateway))
    error_message = "Must be plain IPv4 like '192.168.200.60'."
  }
}
variable "datastore_id" {
  description = "Proxmox datastore ID for the container disk."
  type        = string
}

variable "template_file_id" {
  description = "Template file ID (e.g. isos:vztmpl/<template>.tar.xz)."
  type        = string
}

variable "ssh_public_keys" {
  description = "List of SSH public keys to install for the user account."
  type        = list(string)
}
###########################################
###### OPTIONAL ############################
##############################################

variable "name" {
  description = "Terraform resource name (used only for naming conventions in callers)."
  type        = string
  default     = "container"
}

variable "unprivileged" {
  description = "Whether the container is unprivileged."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the container."
  type        = list(string)
  default     = []
}

variable "user_password" {
  description = "Password for the user account."
  type        = string
  sensitive   = true
}

variable "cpu_architecture" {
  description = "CPU architecture."
  type        = string
  default     = "amd64"
}

variable "cpu_cores" {
  description = "Number of CPU cores."
  type        = number
  default     = 1
}

variable "disk_size_gb" {
  description = "Disk size in GB."
  type        = number
  default     = 32
}

variable "memory_mb" {
  description = "Dedicated memory in MB."
  type        = number
  default     = 3072 
}

variable "swap_mb" {
  description = "Swap size in MB."
  type        = number
  default     = 0
}

variable "os_type" {
  description = "Operating system type."
  type        = string
  default     = "nixos"
}

variable "network_interface_name" {
  description = "Network interface device name."
  type        = string
  default     = "eth0"
}

variable "nesting" {
  description = "Enable nesting feature."
  type        = bool
  default     = true
}
