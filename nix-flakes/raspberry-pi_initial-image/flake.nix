# Modified from:
# https://discourse.nixos.org/t/how-to-move-from-building-sd-card-images-to-be-able-to-remotely-deploy-new-versions/25057

{
  description = "NixOS Raspberry Pi configuration flake";
  outputs = { self, nixpkgs }: {
    nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ({ ... }: {
          config = {
            # Time, keyboard language, etc
            time.timeZone = "America/New_York";
            i18n.defaultLocale = "en_US.UTF-8";


            # User
            users.users.conlan = {
              isNormalUser = true;
              extraGroups = [
                "wheel" # Enable ‘sudo’ for the user.
                "networkmanager"
              ];
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEzI4fdj6ZyIidOX4+CIcbuPCXJgC1to97KvaI+mtC6 conlan@nixos"
              ];
              password = "changethis";
            };

            services.openssh.enable = true;

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

            # This makes the build be a .img instead of a .img.zst
            sdImage.compressImage = false;

            system = {
              stateVersion = "25.05";
            };
          };
        })
      ];
    };
  };
}
#################### Notes
# On the host, requires 
# boot.binfmt.emulatedSystems = ["aarch64-linux"];
# to cross compile.
# 
# Command to build:
# nix build .#nixosConfigurations.rpi.config.system.build.sdImage
