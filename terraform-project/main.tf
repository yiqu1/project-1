resource "azuread_user" "yiqu" {
  user_principal_name = "yiqu@hashicorp.com"
  display_name        = "Yi.Qu"
}

resource "azuread_user" "ibrahim" {
  user_principal_name = "ibrahim@hashicorp.com"
  display_name        = "Ibrahim.Ozbekler"
  force_password_change = true
}

resource "aws_iam_user" "new-users" {
  for_each = toset(var.classmates)
  name = each.value
}

resource "aws_s3_bucket" "buckets" {
  count = var.num_of_instance
  bucket = "bucket-${count.index}"
  tags = {
    Name        = "My bucket-${count.index}"
    Environment = "Dev"
  }
}

resource "azurerm_resource_group" "rg1" {
  name     = "resoucegroup-rg1"
  location = "East Us"
}

resource "azurerm_storage_account" "first" {
  name                     = "storageaccountfirst"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    "name" = "first-sa"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg1.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}