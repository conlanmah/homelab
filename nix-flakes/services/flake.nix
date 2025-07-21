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
      hostDirs = builtins.filter (
        name: let
          path = "${toString hostsDir}/${name}";
        in
          builtins.pathExists "${path}/configuration.nix"
          && builtins.readDir hostsDir.${name} == "directory"
      ) (builtins.attrNames (builtins.readDir hostsDir));

      getSystem = name:
        builtins.readFile (./hosts/${name}/system.nix);

      # Create a function that makes nix configurations from 
      mkHost = name:
        nixpkgs.lib.nixosSystem {
          system = getSystem name; # could be simplified with a let statement
          modules = [
            ./hosts/${name}/configuration.nix
            ./common/default.nix
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
