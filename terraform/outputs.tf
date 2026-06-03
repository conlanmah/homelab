output "hosts" {
  description = "Host information"
  value = {
    for name, container in module.nix_container : name => {
      ips = [for ip in container.ipv4_addresses : trimsuffix(ip, "/24")]
    }
  }
}
