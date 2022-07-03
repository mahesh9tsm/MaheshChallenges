#Create Azure Web network interface

resource "azurerm_network_interface" "dbvmnic" {
  count = 2
  name                = "${local.resource_name_prefix}-dbnic${count.index}"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.demodbsubnet.id
    primary                       = "true"
    name                          = "dbvmconfig${count.index}"
  }
}


#Create Azure Linux VM

resource "azurerm_linux_virtual_machine" "demodbvm" {
  count = 2
  name = "${local.resource_name_prefix}dbvm${count.index}"
  #computer_name = "${local.resource_name_prefix}-appvm0${count.index}"
  resource_group_name = azurerm_resource_group.demorg.name
  location = azurerm_resource_group.demorg.location
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  zone = element(var.zones,(count.index))
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/demo-azure.pub")
  }
   os_disk {
    name = "dbvm${count.index}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
   source_image_reference {
     publisher = "RedHat"
         offer = "RHEL"
           sku = "83-gen2"
       version = "latest"
  }
  network_interface_ids = [ azurerm_network_interface.dbvmnic[count.index].id ]
  custom_data = base64encode(local.demovm_custom_data) 

}



