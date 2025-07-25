# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # todo Garbage collection, swap


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  users.users.conlan = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"
    ];
  };

  environment.systemPackages = with pkgs; [
    gotop
    wireguard-tools
  ];

  nix.settings.trusted-users = [ "root" "conlan" ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Requires to ensure accessibility after reboot
  systemd.services.populate-arp = {
    description = "Ping device to populate ARP table";
    wantedBy = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.iputils}/bin/ping -c 4 192.168.100.60";
    };
  };

  networking = {
    hostName = "rpi3-wireguard";
    networkmanager.enable = true;
    interfaces.enu1u1u1 = {
      ipv4.addresses = [{
        address = "192.168.100.101";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.100.60";
      interface = "enu1u1u1";
    };
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = "enu1u1u1";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.5.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      # postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.5.0/24 -o enu1u1u1 -j MASQUERADE
      # '';

      # This undoes the above command
      # postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.5.0/24 -o enu1u1u1 -j MASQUERADE
      # '';

      # Path to the private key file.
      privateKeyFile = "/home/conlan/wg-keys/private";

      peers = [
        # List of allowed peers.
        { # ThinkpadT14
          # Feel free to give a meaningful name
          # Public key of the peer (not a file path).
          publicKey = "KlwQOo+I9rzTUbZfkciqsEzCDHXP73EXloROjJlCT0M=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.5.2/32" ];
        }
      ];
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

