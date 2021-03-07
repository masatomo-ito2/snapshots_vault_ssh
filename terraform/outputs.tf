output "info" {
  value = <<EOF

Azure VM Hostname:
    ${data.azurerm_public_ip.ip.fqdn}

AWS VM Hostname:
    ${aws_instance.vm.public_dns}
EOF
}


