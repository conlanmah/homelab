# Proxmox API configuration
# Set these via environment variables or a .auto.tfvars file:
#   export TF_VAR_proxmox_api_url="https://proxmox.example.com:8006/api2/json"
#   export TF_VAR_proxmox_api_token="user@pam!token=secret-value"

proxmox_api_url = "https://192.168.200.1:8006/api2/json"

# Defaults for all containers
container_defaults = {
  node_name        = "everforest"
  datastore_id     = "vdisks"
  template_file_id = "isos:vztmpl/nixos-image-lxc-proxmox-25.05.20250112.2f9e2f8-x86_64-linux.tar.xz"
  default_bridge   = "vmbr0"  # Bridge must exist on the target Proxmox node (managed outside Terraform)
  ipv4_gateway     = "192.168.200.60"
  ssh_public_keys  = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"]
  user_password    = "changeme"
  cpu_cores        = 2
  memory_mb        = 2048
  tags             = ["prod"]
}

# Individual containers - only specify what's unique/different
# interfaces: list of NICs. Each entry needs at minimum { ip = "x.x.x.x/24" }.
# Optional per-interface overrides: name (default "eth{n}"), bridge (default default_bridge), gateway (default ipv4_gateway for eth0, null for others)
nix_containers = {
  # "immich" = {
  #   interfaces = [{ ip = "192.168.200.102/24" }]
  #   node_name  = "catpuccin"
  #   cpu_cores  = 4
  #   memory_mb  = 8096
  # }
  "tailscale" = {
    interfaces = [{ ip = "192.168.200.103/24" }]
    cpu_cores  = 1
    memory_mb  = 2048
  }
  "ns1" = {
    interfaces = [{ ip = "192.168.200.32/24" }]
    cpu_cores  = 1
    memory_mb  = 2048
  }
  "ns2" = {
    interfaces = [{ ip = "192.168.200.33/24" }]
    node_name  = "catpuccin"
    cpu_cores  = 1
    memory_mb  = 2048
  }
  # Multi-interface example:
  # "dual-homed" = {
  #   node_name = "nord"
  #   interfaces = [
  #     { ip = "192.168.200.200/24" },                                          # vmbr0, default gateway
  #     { ip = "192.168.150.200/24", bridge = "vmbr1"},    # vmbr1, explicit gateway
  #   ]
  # }
}
