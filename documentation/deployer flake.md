
Requirements:
- Given a terraform provider (proxmox), terraform config, and nix flake, build nix configs for associated terraform defined vms
	- configs can be built by the deployer, the host itself, or another specified host
- Manage passwords and other secrets for hosts
- Build nix container images if necessary as defined in another flake