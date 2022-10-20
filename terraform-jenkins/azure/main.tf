################################################
# Testing Infrastructure for Terraform Modules #
################################################

### General
resource "random_id" "keyvault" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = format("%s-rgp", var.global_id)
  location = var.location
}

### Network

resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-vnet", var.global_id)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = format("%s-subnet", var.global_id)
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "pip" {
  name                = format("%s-ip", var.global_id)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = var.public_domain_name
}

resource "azurerm_network_security_group" "allows" {
  name                = format("%s-nsg", var.global_id)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSshInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHttpsInBound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowJenkinsInBound"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = format("%s-nic", var.global_id)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = format("%s-nic-configuration", var.global_id)
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.allows.id
}


### Virtual Machine

resource "azurerm_virtual_machine" "vm" {
  name                  = format("%s-vm", var.global_id)
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = format("%s-%s-osdisk", var.global_id, random_id.keyvault.hex)
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = format("%s-pc", var.global_id)
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = format("/home/%s/.ssh/authorized_keys", var.admin_username)
      key_data = file(var.ssh_pub_key)
    }
  }

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.pip.ip_address
    user        = var.admin_username
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    source      = "./scripts/jenkins_setup.sh"
    destination = format("/home/%s/jenkins_setup.sh", var.admin_username) 
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/$USER",
      "chmod +x jenkins_setup.sh",
      "/bin/bash /home/$USER/jenkins_setup.sh"
    ]
  }
}