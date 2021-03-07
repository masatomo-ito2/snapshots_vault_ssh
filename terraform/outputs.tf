output "info" {
  value = <<EOF

Azure VM:
    ssh ubuntu@${data.azurerm_public_ip.ip.fqdn}

AWS VM:
    ssh ubuntu@${aws_instance.vm.public_dns}
EOF
}


