
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

Configuration Variables for Tool:
- Command Host public key, this will be added to all terraform provisioned hosts
- Flake path
- Terraform path

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
- `tn check`
	- Confirms there are no configuration conflicts between NixOS and Terraform
		- Hostname
		- Networking
		- Password
- `tn help`
- `tn doctor`
	- tests terraform provider
	- verifies paths in configuration file
	- confirms secrets management

NixOS and Terraform config conflicts:
- Hostname, must match in both. Terraform provision overrides Nix lxc tar, but nix rebuilds will overrride Terraform.
- Networking:
	- Can allow NixOS to defer to Terraform with: `systemd.network.enable = true;`
	- Although dhcp with ddns may complicate this
- Password, NixOS overrides
	- I can apply ssh keys via terraform, but not passwords.