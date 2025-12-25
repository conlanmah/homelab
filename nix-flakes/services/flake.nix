# Build with: `nixos-rebuild switch --flake .#<hostname> --target-host conlan@<ip-addr> --sudo`
{
  description = "Creates configurations for all homelab services";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    # flake-utils,
    ...
  }:
    let
      hostsDir = ./hosts;

      # Create list of directories in ./hosts that contains a configuration.nix
      hostDirs =
        let
          entries = builtins.readDir hostsDir;
        in
          builtins.filter (name:
            entries.${name} == "directory"
            && builtins.pathExists (hostsDir + "/${name}/configuration.nix")
          ) (builtins.attrNames entries);

      getSystem = name:
        builtins.readFile (./hosts/${name}/system.nix);

      # Create a function that makes nix configurations from 
      mkHost = name:
        nixpkgs.lib.nixosSystem {
          system = getSystem name; # could be simplified with a let statement
          modules = [
            ./hosts/${name}/configuration.nix
          ];
          specialArgs = { system = getSystem name;};
        };

      nixosConfigurations = builtins.listToAttrs (
        builtins.map (name: {
          name = name;
          value = mkHost name;
        })
        hostDirs
      );
    in {
      inherit nixosConfigurations;

    };
}
