{
  description = "Provides an environment for deploying configurations to homelab
                 machines, including signing for remote building. When building
                 for architecture that is different than the machine doing the
                 building, emulation is required. Enabling this varies between OS's";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  # Chat GPT created with minimal packages required for building 
  # Use the ++ syntax to extend packages per each devShell, other
  # wise, the 'commonPackages' variable contains packages shared
  # across both x86 and aarch architectures
 outputs = { self, nixpkgs, ... }: let
    # Shared base package list
    getBasePackages = pkgs: with pkgs; [
      nix
      nixos-rebuild
      nixos-generators # for creating lxc tar
      openssh
      terraform
    ];

    # Shared shellHook generator
    makeShellHook = system: ''
      export
      echo "✅ Nix deploy shell ready for ${system}"
    '';
  in {
    devShells = {
      x86_64-linux = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { 
          inherit system; 
          config.allowUnfree = true;
        };
      in {
        default = pkgs.mkShell {
          packages = getBasePackages pkgs;
          shellHook = makeShellHook system;
        };
      };

      aarch64-linux = let
        system = "aarch64-linux";
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          packages = getBasePackages pkgs;
          shellHook = makeShellHook system;
        };
      };
    };
  };
}
