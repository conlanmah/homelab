

{ config, modulesPath, pkgs, lib, ... }:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];
  nix.settings = { sandbox = false; };  
  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  services.openssh = {
    enable = true;
    # openFirewall = true;
  };
  networking = {
    hostName = "immich-mars";
    interfaces = {
      eth0.ipv4.addresses = [{
        address = "192.168.100.102";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.100.60";
      interface = "eth0";
    };

    nameservers = ["192.168.50.1" "8.8.8.8"];
    firewall.enable = true;
  };
  users.users.conlan = {
    isNormalUser = true;
    description = "conlan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"
    ];
  };
  
  nix.settings.trusted-users = [ "root" "conlan" ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
