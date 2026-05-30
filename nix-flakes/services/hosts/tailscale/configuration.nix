# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{

  ############################################################
  # Tailscale
  ############################################################

  services.tailscale = {
    enable = true;
    interfaceName = "userspace-networking";
    useRoutingFeatures = "server";
    extraSetFlags = [
      # "--advertise-exit-node"
      "--advertise-routes=192.168.200.0/24"
    ];
  };


  ############################################################
  # Container / Proxmox LXC baseline
  ############################################################
  boot.isContainer = true;

  # Allows Terraform to set password
  users.mutableUsers = true;
  # These two lines are essential for container functionality.
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  # Proxmox typically governs filtering; avoid "SSH is up but blocked"
  # networking.firewall.enable = false;

  # Helpful in containers: don't block boot waiting for "online"
  systemd.network.wait-online.enable = false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  ############################################################
  # Networking (Proxmox LXC generally presents eth0)
  ############################################################
  networking.hostName = "tailscale";
  networking.useDHCP = false;
  systemd.network.enable = true;
  # networking.interfaces.eth0.useDHCP = false;
  services.resolved.enable = true;

  ############################################################
  # SSH
  ############################################################
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  ###### NEVER CHANGE THIS
  system.stateVersion = "25.05";
}
