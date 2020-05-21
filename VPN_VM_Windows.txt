####################### create VM Windows #################
 ##############################
# variable "prefixMDS" {
#  default = "MDS_us"
#}

resource "azurerm_subnet" "internal2" {
  name                 = "${var.prefixMDS}-internal2"
  resource_group_name  = azurerm_resource_group.MDS_us.name
  virtual_network_name = azurerm_virtual_network.MDS_us_vnet.name
  address_prefix       = "10.0.4.0/24"
}

resource "azurerm_network_interface" "MDSNIC2" {
  name                = "${var.prefixMDS}-nic2"
  location            = azurerm_resource_group.MDS_us.location
  resource_group_name = azurerm_resource_group.MDS_us.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "MDSVM02" {
  name                  = "${var.prefixMDS}-vm2"
  location              = azurerm_resource_group.MDS_us.location
  resource_group_name   = azurerm_resource_group.MDS_us.name
  network_interface_ids = [azurerm_network_interface.MDSNIC2.id]
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