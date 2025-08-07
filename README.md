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
- [ ] Wrapper for nixos-rebuild that makes targeting remote hosts easy
- [x] Test Harddrives
- [x] Install T330
- [ ] Figure out secrets management
- [x] Add Proxmox Nodes to cluster
- [ ] Research and get/build a UPS
	- [ ] Configure nut-client
- [x] Reorganize physical devices
	- [x] Add cables for second NAT on mini's 
- [ ] Update Diagrams
- [ ] Immich
	- [ ] Create nfs share
		- [ ] ensure zfs auto snapshot
	- [ ] Fine tune settings
	- [ ] determine how to share with family

Large Steps:
- [ ] backup wireguard instance
- [ ] Borg Backup or Proxmox Backup
- [ ] DNS or DDNS
- [ ] Reverse Proxy
- [ ] Terraform for Proxmox
- [ ] LDAP
- [ ] Paperless NGX
- [ ] Find My Device
- [ ] Gafana for dashboard
- [ ] Uptime Kuma for Reporting
- [ ] RSS reader
- [ ] Wallabag for storing articles to read
- [ ] copyparty for a file server
- [ ] NTP?
- [ ] Kerberos

