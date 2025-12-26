# General

| OS    | hostname | domain    | DNS          |
| ----- | -------- | --------- | ------------ |
| NixOS | gruvbox  | home.arpa | 192.168.50.1 |
# Interfaces

| Interface | IP               | Purpose    | Gateway        |
| --------- | ---------------- | ---------- | -------------- |
| eno1      | 192.168.200.4/24 | Management | 192.168.200.60 |
| eno2      | 192.168.150.4/24 | Storage    | N/A            |
# Specs

| Model               | CPU | RAM            |
| ------------------- | --- | -------------- |
| Dell PowerEdge T330 |     | 32 GB ECC-DDR4 |
# Storage

| Type    | Size  | Purpose |
| ------- | ----- | ------- |
| SSD     | 512GB | Proxmox |
| HDD(#3) | 18TB  | RAID1   |
| HDD(#4) | 18TB  | RAID1   |



| # Opened | Model | SMART  | Conveyance Self-test | Short Self-test | Extended selt-test |
| -------- | ----- | ------ | -------------------- | --------------- | ------------------ |
| 1        | Same  | Passed | passed               | passed          | passed             |
| 2        | same  | Passed | passed               | passed          | passed             |
| 3        | same  | Passed | passed               | passed          | passed             |
| 4        | same  | Passed | passed               | passed          | passed             |
From smartmontools for drive 3 or 4:

```
=== START OF INFORMATION SECTION ===
Model Family:     Seagate Exos X18
Device Model:     ST18000NM000J-2TV103
Serial Number:    ZR5FSB85
LU WWN Device Id: 5 000c50 0e98e0d7d
Firmware Version: SN04
User Capacity:    18,000,207,937,536 bytes [18.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database 7.5/5706
ATA Version is:   ACS-4 (minor revision not indicated)
SATA Version is:  SATA 3.3, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Jul 28 22:12:40 2025 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
```

## ZFS configuration

This is imperative, because by nature it is done a single time and there is no good, non-destructive way to do so imperatively. Disko will destroy data.


ZFS Tuning from https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/:
- ashift=12
	- Critical, must match underlying physical sector size, 4KiB
- compression=lz4
	- Very fast, will not become a bottle neck and will save space
- atime=off
	- Usually not necessary to track 'accessed' on each file. Must be done very frequently so saves cpu.
- recordsize=128K
	- Stick with default as HDD's latency is mostly seek time so therefore this is not super important?
- SLOG=maybe?
	- Kinda like journalling, useful in event of a crash but requires reliable flash storage, which the SSD is not?..

Commands:
```bash
sudo zpool create -o ashift=12 tank mirror /dev/sda /dev/sdb
# -f needed to overwrite existing fs's
sudo zfs set compression=lz4 tank

sudo zfs set atime=off tank
# zfs commands applied to pool because its the 'root dataset' which is just at the top level of the pool

# Reservation to ensure pool performance
sudo zfs create -o refreservation=3T -o mountpoint=none tank/reserved
```

## Datasets


| Name   | Purpose               | NFS                                                       |
| ------ | --------------------- | --------------------------------------------------------- |
| vdisks | Proxmox Virtual Disks | 192.168.150.0/24(rw,sync,no_root_squash,no_subtree_check) |
| isos   | Linux ISOs            | 192.168.150.0/24(ro,sync,no_root_squash,no_subtree_check) |

no_root_squash is slightly insecure, but not a super large issue as the NFS shares are fairly inaccessible.

Commands for `isos` because proxmox expects a file structure if it can't write.
```bash
sudo mkdir -p /tank/isos/template/cache
sudo mkdir -p /tank/isos/template/iso
sudo chown -R root:root /tank/isos/template
sudo chmod -R 755 /tank/isos/template
```