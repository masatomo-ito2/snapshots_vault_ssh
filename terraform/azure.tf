locals {
  rg_name     = data.terraform_remote_state.azure_state.outputs.rg_name
  rg_location = data.terraform_remote_state.azure_state.outputs.rg_location
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = local.rg_name
  vnet_name           = "vnet"
  address_space       = "10.1.0.0/16"
  subnet_prefixes     = ["10.1.0.0/24"]
  subnet_names        = ["snapshots"]

  tags = {
    owner = "masa@hashicorp.com"
  }
}

#  Add security rule to network
module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = local.rg_name
  address_space       = ["10.1.0.0/16"]
  subnet_prefixes     = ["10.1.0.0/24"]
  subnet_names        = ["snapshots"]
  nsg_ids = {
    snapshots = azurerm_network_security_group.sg.id
  }

  tags = {
    env = "var.env"
  }

  depends_on = [module.network]
}

resource "azurerm_network_security_group" "sg" {
  name                = var.env
  resource_group_name = local.rg_name
  location            = local.rg_location
}

locals {
  nsg_rules = {
    ssh = {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_network_security_rule" "rules" {
  for_each                    = local.nsg_rules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = local.rg_name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_public_ip" "ip" {
  name                = var.env
  resource_group_name = local.rg_name
  location            = local.rg_location
  allocation_method   = "Static"
  domain_name_label   = "snapshots"
}

resource "azurerm_network_interface" "nic" {
  name                = var.env
  resource_group_name = local.rg_name
  location            = local.rg_location

  ip_configuration {
    name                          = "config"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  tags = {
    Name = var.env
    Env  = var.env
  }

}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.env
  location              = local.rg_location
  resource_group_name   = local.rg_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_B1LS"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name = var.env
  # custom_data   = base64encode(data.template_file.azure-server-init.rendered)
  custom_data = base64encode(templatefile("${path.module}/${var.template_path}", { tpl_vault_addr = var.vault_addr, tpl_vault_namespace = var.vault_namespace }))

  disable_password_authentication = true

  admin_username = "ubuntu"
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/HashiCorp/demo/credentials/azure/ssh/masa_azure.pub")
  }

  tags = {
    Name = var.env
    Env  = var.env
  }
}

/*
data "template_file" "azure-server-init" {
  template = file("${path.module}/scripts/setup.sh")
  vars = {
    tpl_vault_addr      = var.vault_addr
    tpl_vault_namespace = var.vault_namespace
  }
}
*/

# Obtain public DNS name

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.ip.name
  resource_group_name = local.rg_name
}
