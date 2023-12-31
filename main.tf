# Azure provider configuration
provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  tenant_id                  = var.tenant_id
}

# Azure resource group
resource "azurerm_resource_group" "pygrp" {
  name     = "myResourceGroup"
  location = "East US"
}

# Azure virtual network
resource "azurerm_virtual_network" "pyvnet" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.pygrp.location
  resource_group_name = azurerm_resource_group.pygrp.name
}

# Azure subnet for Azure Bastion
resource "azurerm_subnet" "pysub" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.pygrp.name
  virtual_network_name = azurerm_virtual_network.pyvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Azure subnet for virtual machine
resource "azurerm_subnet" "vm" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.pygrp.name
  virtual_network_name = azurerm_virtual_network.pyvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Azure public IP for the virtual machine
resource "azurerm_public_ip" "pypub" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.pygrp.location
  resource_group_name = azurerm_resource_group.pygrp.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure network interface for the virtual machine
resource "azurerm_network_interface" "pyint" {
  name                = "myNIC"
  location            = azurerm_resource_group.pygrp.location
  resource_group_name = azurerm_resource_group.pygrp.name

  ip_configuration {
    name                          = "myNICConfig"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id           = azurerm_public_ip.pypub.id
  }
}

# Azure Linux virtual machine
resource "azurerm_linux_virtual_machine" "pyvm" {
  name                            = "myVM"
  location                        = azurerm_resource_group.pygrp.location
  resource_group_name             = azurerm_resource_group.pygrp.name
  size                            = "Standard_DS1_v2"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.pyint.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(
    <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    sudo docker pull shadrach85/py_flash:latest
    sudo docker run -d -p 5000:5000 shadrach85/py_flash:latest
    EOF
  )
}

# Azure Bastion host
resource "azurerm_bastion_host" "pybastion" {
  name                = "examplebastion"
  location            = azurerm_resource_group.pygrp.location
  resource_group_name = azurerm_resource_group.pygrp.name
  sku                 = "Standard"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.pysub.id
    public_ip_address_id = azurerm_public_ip.pypub.id
  }
}

# Output for public IP address of the virtual machine
output "public_ip_address" {
  value = azurerm_public_ip.pypub.ip_address
}

# Azure subnet for application gateway
resource "azurerm_subnet" "agsubnet" {
  name                 = "agSubnet"
  resource_group_name  = azurerm_resource_group.pygrp.name
  virtual_network_name = azurerm_virtual_network.pyvnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Azure application gateway
resource "azurerm_application_gateway" "pygateway" {
  name                = "pyAppGateway"
  resource_group_name = azurerm_resource_group.pygrp.name
  location            = azurerm_resource_group.pygrp.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.agsubnet.id
  }

  frontend_port {
    name = "port_5000"
    port = 5000
  }

  frontend_ip_configuration {
    name                 = "frontendIpConfig"
    public_ip_address_id = azurerm_public_ip.gateway_ip.id
  }

  backend_address_pool {
    name         = "backendPool"
    ip_addresses = [azurerm_linux_virtual_machine.pyvm.private_ip_address]
  }

  backend_http_settings {
    name                  = "backendSettings"
    port                  = 5000
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontendIpConfig"
    frontend_port_name             = "port_5000"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routingRule"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "backendSettings"
    priority                   = 1
  }
}

# Azure public IP for the application gateway
resource "azurerm_public_ip" "gateway_ip" {
  name                = "gateway-ip"
  location            = azurerm_resource_group.pygrp.location
  resource_group_name = azurerm_resource_group.pygrp.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Output for public IP address of the application gateway
output "gateway_ip" {
  value = azurerm_public_ip.gateway_ip.ip_address
}

