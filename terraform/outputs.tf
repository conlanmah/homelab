output "hosts" {
  description = "Host information for ntd"
  value = {
    for name, container in module.nix_container : name => {
      ip = trimsuffix(container.ipv4_address, "/24")
    }
  }
}
