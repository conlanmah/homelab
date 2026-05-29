# Proxmox API configuration
# Set these via environment variables or a .auto.tfvars file:
#   export TF_VAR_proxmox_api_url="https://proxmox.example.com:8006/api2/json"
#   export TF_VAR_proxmox_api_token="user@pam!token=secret-value"

proxmox_api_url= "https://192.168.200.1:8006/api2/json"

# Defaults for all containers
container_defaults = {
  node_name        = "everforest"
  datastore_id     = "vdisks"
  template_file_id = "isos:vztmpl/nixos-image-lxc-proxmox-25.05.20250112.2f9e2f8-x86_64-linux.tar.xz"
  ipv4_gateway     = "192.168.200.60"
  ssh_public_keys  = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"]
  user_password    = "changeme"
  cpu_cores        = 2
  memory_mb        = 2048
  tags             = ["prod"]
}

# Individual containers - only specify what's unique/different
nix_containers = {
  # "nix-ct-test-02" = {
  #   ipv4_address = "192.168.200.104/24"
  # }
  # "nix-ct-test-03" = {
  #   ipv4_address = "192.168.200.103/24"
  #   # node_name = "nord"
  #   # cpu_cores = 1
  # }
}
