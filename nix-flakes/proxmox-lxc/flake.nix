{
  description = "NixOS Proxmox LXC tarball, SSH-ready immediately";

  inputs = {
    # for some reason the final built tarbell is listed as 25.05
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-generators.url = "github:nix-community/nixos-generators";
  };

  outputs = { self, nixpkgs, nixos-generators, ... }:
    let
      system = "x86_64-linux";
    in
    {
      packages = {
        ${system} = 
          let
            proxmox-lxc = nixos-generators.nixosGenerate {
              inherit system;
              format = "proxmox-lxc";

              modules = [
                ({ lib, pkgs, ... }:
                  {
                    ############################################################
                    # Container / Proxmox LXC baseline
                    ############################################################
                    boot.isContainer = true;

                    # Allows Terraform to set password 
                    users.mutableUsers = true;

                    # Proxmox typically governs filtering; avoid "SSH is up but blocked"
                    # networking.firewall.enable = false;

                    # Helpful in containers: don't block boot waiting for "online"
                    systemd.network.wait-online.enable = false;
                    systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

                    ############################################################
                    # Networking (Proxmox LXC generally presents eth0)
                    ############################################################
                    networking.hostName = "nixos-lxc";

                    # Be explicit: use systemd-networkd and DHCP on eth0.
                    # networking.useNetworkd = true; # Experimental
                    systemd.network.enable = true;
                    networking.useDHCP = false;
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
                    # TODO Replace
                    # users.users.root.openssh.authorizedKeys.keys = [
                    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"
                    # ];
                    
                    security.sudo = {
                      enable = true;
                      wheelNeedsPassword = false;
                    };

                    ############################################################
                    # Container niceties / reduce console noise
                    ############################################################
                    # Proxmox console works, but getty management can be weird in LXCs.
                    # Disabling autovt/getty reduces useless units/log noise.
                    # systemd.services."getty@tty1".enable = lib.mkDefault false;
                    # systemd.services."autovt@tty1".enable = lib.mkDefault false;

                    environment.systemPackages = with pkgs; [
                      curl
                      git
                      vim
                    ];

                    nix.settings.experimental-features = [ "nix-command" "flakes" ];

                    time.timeZone = "UTC";
                    i18n.defaultLocale = "en_US.UTF-8";

                    # Ya Dee De, blah blah danger danger, idk what this even does
                    system.stateVersion = "25.11";
                  })
                ];
              };
            in 
            {
              inherit proxmox-lxc;
              default = proxmox-lxc;
            };
      };
    };
}
