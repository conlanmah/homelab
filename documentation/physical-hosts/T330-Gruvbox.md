# General

| OS      | hostname | domain    | DNS          |
| ------- | -------- | --------- | ------------ |
| Proxmox | gruvbox  | home.arpa | 192.168.50.1 |
# Interfaces

| Interface | IP            | Purpose    | Gateway        |
| --------- | ------------- | ---------- | -------------- |
| eno1      | 192.168.100.4 | Management | 192.168.100.60 |
# Specs

| Model               | CPU | RAM            |
| ------------------- | --- | -------------- |
| Dell PowerEdge T330 |     | 32 GB ECC-DDR4 |
# Storage

| Type | Size  | Purpose   |
| ---- | ----- | --------- |
| SSD  | 512GB | Proxmox   |
| HDD  | 500GB | RAID1     |
| HDD  | 500GB | RAID1     |
| HDD  | 500GB | Hot Spare |


| # Opened | Model | SMART  | Conveyance Self-test | Short Self-test | Extended selt-test |
| -------- | ----- | ------ | -------------------- | --------------- | ------------------ |
| 1        | Same  | Passed | passed               | passed          |                    |
| 2        | same  | Passed | passed               | passed          | passed             |
| 3        | same  | Passed | passed               | passed          | passed             |
| 4        | same  | Passed | passed               | passed          | passed             |
