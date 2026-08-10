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
  networking.hostName = "karakeep";
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

  ############################################################
  # Karakeep 
  ############################################################

  services.karakeep = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop  
  ];

  environment.sessionVariables = { 
    NEXTAUTH_URL = "http://karakeep.mah:3000";
    NEXTAUTH_SECRET = "LwjAe02E5FUvt3Zu7/3YJVMMDSyrxMj6XIMC84JoJHsws+Bq";
  };

  networking.firewall.allowedTCPPorts = [3000]; 

  # fileSystems."/mnt/karakeep" = {
  #   device = "192.168.150.4:/export/karakeep";
  #   fsType = "nfs";
  # };
  # boot.supportedFilesystems = ["nfs"];

  ###### NEVER CHANGE THIS
  system.stateVersion = "26.05";
}
