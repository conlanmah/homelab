
# General

| OS    | hostname | domain | DNS          |
| ----- | -------- | ------ | ------------ |
| NixOS | dracula  |        | 192.168.50.1 |
# Interfaces

| Interface | IP                 | Purpose | Gateway        |
| --------- | ------------------ | ------- | -------------- |
| enu1u1u1  | 192.168.100.101/24 |         | 192.168.100.60 |
# Specs

| Model | CPU | RAM    |
| ----- | --- | ------ |
| 3B+   |     | 866MiB |
# Storage

| Type    | Size | Purpose |
| ------- | ---- | ------- |
| SD Card | 16GB | boot    |

# Configuration

Because the Pi really can't handling 'nix-rebuild' on it's own, the initial image including networking info was cross compiling on my laptop. Additionally, all builds will be done on my laptop and then sent to the device.

## Initial Image

After adding:
`boot.binfmt.emulatedSystems = ["aarch64-linux"];`
To my laptop's Nix config so that it could correctly emulate the aarch64 architecture, I was able to build the flake using: 
`nix build .#nixosConfigurations.rpi.config.system.build.sdImage`
This resulted in an `.img` file which I could flash to the sd card using `dd`. 
https://wiki.nixos.org/wiki/NixOS_on_ARM/Installation

# 