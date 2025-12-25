# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [./hardware-configuration.nix];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {

    hostName = "gruvbox";

    networkmanager.enable = true;

    interfaces = {
      eno1.ipv4.addresses = [{
        address = "192.168.200.4";
        prefixLength = 24;
      }];
      eno2.ipv4.addresses = [{
        address = "192.168.150.4";
        prefixLength = 24;
      }];
    };

    defaultGateway = {
      address = "192.168.200.60";
      interface = "eno1";
    };

    nameservers = ["192.168.50.1" "8.8.8.8"];

    firewall = {
      enable = true;
      interfaces."eno2" = {
        # for NFSv3; view with `rpcinfo -p`
        allowedTCPPorts = [ 111  2049 4000 4001 4002 20048 ];
        allowedUDPPorts = [ 111 2049 4000 4001  4002 20048 ];
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  
  nix.settings.trusted-users = [ "root" "conlan" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  ######################################################################
  ################################### USERS ############################
  ######################################################################
  
  users.users = {
    conlan = {
      isNormalUser = true;
      description = "conlan";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"
      ];
    };
    immich = {
      isSystemUser = true;
      uid = 104;
      group = "immich";
    };
  };

  users.groups = {
    immich = {gid = 104;};
  };

  ################################################################
  ################ ZFS Settings ##################################
  ################################################################
  
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "tank" ];
  networking.hostId = "f5a224c1"; # Random id for importing zpools to a single system
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
    autoSnapshot.enable = true;
  };


  #################################################################
  ################ NFS Settings ###################################
  #################################################################

  fileSystems."/export/vdisks" = {
    device = "/tank/vdisks";
    options = [ "bind" "x-systemd.requires=zfs-mount.service" "x-systemd.after=zfs-mount.service" ];
  }; 
  fileSystems."/export/isos" = {
    device = "/tank/isos";
    options = [ "bind" "x-systemd.requires=zfs-mount.service" "x-systemd.after=zfs-mount.service" ];
  }; 
  fileSystems."/export/immich-mars" = {
    device = "/tank/immich-mars";
    options = [ "bind" "x-systemd.requires=zfs-mount.service" "x-systemd.after=zfs-mount.service" ];
  }; 

  # Could easily make this a function, also is not nessesarily required
  # But is in general good practice and separates ZFS from NFS a bit

  services.nfs.server = {
    enable = true;

    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;

    # TEMP CONFIG
    # NARROW TO 150.0/24 ONCE DONE 
    exports = ''
      /export/vdisks        192.168.150.0/24(rw,sync,no_root_squash,no_subtree_check)
      /export/isos          192.168.150.0/24(rw,sync,no_root_squash,no_subtree_check)
      /export/immich-mars   192.168.150.102(rw,sync,no_root_squash,no_subtree_check)
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
