provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "web_radio" {
  name     = "web-radio"
  location = "UK South"
}

resource "azurerm_public_ip" "web_radio" {
  name                = "webradio-pip"
  resource_group_name = azurerm_resource_group.web_radio.name
  location            = azurerm_resource_group.web_radio.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
resource "azurerm_virtual_network" "web_radio" {
  name                = "web-radio"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.web_radio.location
  resource_group_name = azurerm_resource_group.web_radio.name
}

resource "azurerm_subnet" "web_radio" {
  name                 = "web-radio"
  resource_group_name  = azurerm_resource_group.web_radio.name
  virtual_network_name = azurerm_virtual_network.web_radio.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "web-radio-nic"
  location            = azurerm_resource_group.web_radio.location
  resource_group_name = azurerm_resource_group.web_radio.name

  ip_configuration {
    name                          = "web-radio"
    subnet_id                     = azurerm_subnet.web_radio.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_radio.id
  }
}

resource "azurerm_linux_virtual_machine" "web_radio" {
  name                = "web-radio-vm"
  resource_group_name = azurerm_resource_group.web_radio.name
  location            = azurerm_resource_group.web_radio.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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
}
