 ####################### create VM Ubuntu #################
 
variable "prefix" {
  default = "MDS_us"
}
 
resource "azurerm_resource_group" "MDS_us" {
  name     = "${var.prefix}-resources"
  location = "West US "
}

resource "azurerm_virtual_network" "MDS_us_vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.MDS_us.location
  resource_group_name = azurerm_resource_group.MDS_us.name
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.MDS_us.name
  virtual_network_name = azurerm_virtual_network.MDS_us_vnet.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "MDSNIC" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.MDS_us.location
  resource_group_name = azurerm_resource_group.MDS_us.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "MDSVM01" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.MDS_us.location
  resource_group_name   = azurerm_resource_group.MDS_us.name
  network_interface_ids = [azurerm_network_interface.MDSNIC.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "MDSosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "MDSVM"
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

