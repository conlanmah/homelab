{
  description = "Creates configurations for all homelab services";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      hostsDir = ./hosts;

      # Create list of directories in ./hosts that contains a configuration.nix
      hostDirs = builtins.filter (
        name: let
          path = "${toString hostsDir}/${name}";
        in
          builtins.pathExists "${path}/configuration.nix"
          && builtins.readDir hostsDir.${name} == "directory"
      ) (builtins.attrNames (builtins.readDir hostsDir));

      # Create a function that makes nix configurations from 
      mkHost = name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${name}/configuration.nix
            ./common/default.nix
          ];
          specialArgs = {inherit system;};
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

      packages.default =
        # fallback: default to the first host if one exists
        if nixosConfigurations != {}
        then (builtins.head (builtins.attrValues nixosConfigurations)).config.system.build.toplevel
        else throw "No valid hosts found in ./hosts/";
    });
}
