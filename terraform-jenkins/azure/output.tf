output "pub_ip_address" {
    value = azurerm_public_ip.pip.ip_address
}

output "dns_address" {
    value = azurerm_public_ip.pip.fqdn
}