
| VLAN ID | Purpose            | Network           | IP                     |
| ------- | ------------------ | ----------------- | ---------------------- |
| 10      | Home Lan           | 192.168.50.0/24   | 192.168.50.60          |
| 20      | Proxmox Management | 192.168.100.0/24  | 192.168.100.60         |
| 30      | Proxmox Cluster    | 192.168.150.60/24 | No ip prevents routing |

Ports, Dell logo right side up
##: VLAN ID
T: Trunk Port
A: Access Port

| 10A |     |     | 20A | 20A | 20A | 20A | 20A | SFP Port Unused |
| --- | --- | --- | --- | --- | --- | --- | --- | --------------- |
|     |     |     |     | 30A | 30A | 30A | 30A | SFP Port Unused |
