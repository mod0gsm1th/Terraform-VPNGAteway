 ####################### create VM Windows #################
 ##############################
 variable "prefixMDS" {
  default = "MDS_us"
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefixMDS}-internal"
  resource_group_name  = azurerm_resource_group.MDS_us.name
  virtual_network_name = azurerm_virtual_network.MDS_us_vnet.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "MDSNIC" {
  name                = "${var.prefixMDS}-nic"
  location            = azurerm_resource_group.MDS_us.location
  resource_group_name = azurerm_resource_group.MDS_us.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "MDSVM02" {
  name                  = "${var.prefixMDS}-vm"
  location              = azurerm_resource_group.MDS_us.location
  resource_group_name   = azurerm_resource_group.MDS_us.name
  network_interface_ids = [azurerm_network_interface.MDSNIC.id]
  vm_size               = "Standard_DS1_v2"

 
storage_image_reference  {
        publisher   = "MicrosoftWindowsServer"
        offer       = "WindowsServer"
       sku         = "2016-Datacenter"
       version     = "latest"
    }
    storage_os_disk {
       name          = "MDSosdisk3"
     #  vhd_uri       = "${azurerm_storage_account.azrmstgacc-stdssdlrs-001.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/dcsazprois002-os.vhd"
        caching       = "ReadWrite"
        create_option = "FromImage"
        os_type       = "Windows"
    }
     os_profile {
        computer_name  = "MDSVM3"
        admin_username = "testadmin"
        admin_password = "Password1234!"
    } 
os_profile_windows_config {
    provision_vm_agent  = true
  }
 }