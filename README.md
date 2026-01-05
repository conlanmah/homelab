# homelab
A Proxmox and NixOS based homelab

# TODO

- [x] Wireguard on RPi
	- [ ] ~~Create deploy/builder flake that manages signing~~
	- [ ] ~~Update the initial image to trust the signing key
	- [x] Remote deploy first configuration
	- [x] Wireguard Config
- [x] Re-plan how to share storage from T330
- [x] Build out T330 config, NFS on ZFS
	- [x] Add Linux ISO's dataset
- [x] Test Harddrives
- [x] Install T330
- [x] Add Proxmox Nodes to cluster
- [ ] Research and get/build a UPS
	- [ ] Configure nut-client
- [x] Reorganize physical devices
	- [x] Add cables for second NAT on mini's 
- [x] Update Diagrams
- [ ] Immich
	- [x] Create nfs share
		- [x] ensure zfs auto snapshot
	- [x] Fine tune settings
- [x] Set up everforest host
	- [x] Research how Proxmox backup works
- [x] Fix IP Addresses
	- [x] Switch
	- [x] wg pi
	- [x] Data server
	- [x] Cluster Nodes
- [ ] Deployer flake
	- [ ] nixos-rebuild wrapper, use nh probably
	- [ ] direnv prolly
	- [ ] determine if terraform integration is better now for addressing
	- [ ] secrets management
	- [ ] dedicated builder host?
		- [ ] where to put the base nix image?
- [ ] NFS id binding on gruvbox
- [ ] Tailscale

Large Steps:
- [ ] backup wireguard instance
- [ ] Borg Backup or Proxmox Backup
- [ ] DNS or DDNS, Google domains
	- [ ] NGINX for local domains or SWAG?
- [ ] Extended Internet Access
	- [ ] Reverse Proxy or
	- [ ] DMZ or
	- [ ] headscale VPS
- [ ] Terraform for Proxmox
- [ ] IP fabric?
- [ ] Directory Services/SSO
	- [ ] Kerberos?
	- [ ] LDAP?
- [ ] Paperless NGX
- [ ] Find My Device
- [ ] Gafana for dashboard
- [ ] Uptime Kuma for Reporting
- [ ] RSS reader
- [ ] Wallabag for storing articles to read
- [ ] copyparty for a file server
- [ ] NTP?
- [ ] Music hosting recommended by O
- [ ] Redo EVERYTHING once the proxmox-nixos project matures and stabilizes

