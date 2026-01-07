
Requirements:
- Given a terraform provider (proxmox), terraform config, and nix flake, build nix configs for associated terraform defined vms
	- configs can be built by the deployer, the host itself, or another specified host
- Manage passwords and other secrets for hosts
- Build nix container images if necessary as defined in another flake

Terraform:
- Read from `terraform output -json`

Workflow:
1. Load terraform outputs
2. Plan each build
	1. Ensure terraform machines and nix flake configurations line up
	2. Determine local, self, or remote builds
	3. Ensure secrets exist
3. Execute

Commands:
- `tn build <targets>`
	- builds target vms and containers defined in the terraform and nix configurations
	- Defaults to all vms and containers if no target is specified
	- `--dryrun` 
- `tn configure`
	- Opens configuration file for the flake
		- Defines nix configurations, terraform plan,
- `tn list`
	- Lists containers and vms in terraform and nix
	- Highlights configurations in terraform that don't have a corresponding nix configuration and vice versa
- `tn help`
- `tn doctor`
	- tests terraform provider
	- verifies paths in configuration file
	- confirms secrets management