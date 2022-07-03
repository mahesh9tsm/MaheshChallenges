#Create Azure Web network interface

resource "azurerm_network_interface" "demovmnic" {
  count = 2
  name                = "${local.resource_name_prefix}-webnic${count.index}"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.demowebsubnet.id
    primary                       = "true"
    name                          = "webvmconfig${count.index}"
  }
}

# Local blocks for custom date
locals {
demovm_custom_data = <<CUSTOM_DATA
#!/bin/sh
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd  
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo chmod -R 777 /var/www/html 
sudo echo "VM Hostname: $(hostname)" > /var/www/html/index.html


CUSTOM_DATA  
}


#Create Azure Linux VM

resource "azurerm_linux_virtual_machine" "demowebvm" {
  count = 2
  name = "${local.resource_name_prefix}webvm${count.index}"
  #computer_name = "${local.resource_name_prefix}-webvm0${count.index}"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  size                = "Standard_B2ms"
  admin_username      = "azureuser"
  zone                = element(var.zones,(count.index))
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/demo-azure.pub")
  }
   os_disk {
    name = "webvm${count.index}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
   source_image_reference {
     publisher = "RedHat"
         offer = "RHEL"
           sku = "83-gen2"
       version = "latest"
  }
  network_interface_ids = [ azurerm_network_interface.demovmnic[count.index].id]
  custom_data = base64encode(local.demovm_custom_data) 

}



