

module "nix-ct-test-02" {
    source = "./modules/nix-ct"
    template_file_id = var.nix_ct_temp
    user_password = "testpass-!$"
    hostname = "nix-ct-test-02"
    datastore_id = "vdisks"
    ssh_public_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"]
    node_name = "everforest"
    ipv4_address = "192.168.200.104/24"
    ipv4_gateway = var.ipv4_gateway
}
