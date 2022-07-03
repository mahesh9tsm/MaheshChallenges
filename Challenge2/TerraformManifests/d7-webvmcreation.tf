
# Resource-1: Create Public IP Address
resource "azurerm_public_ip" "web_linuxvm_publicip" {
  name = "${local.resource_name_prefix}-web-linuxvm-publicip"
  resource_group_name = azurerm_resource_group.demorg.name
  location = azurerm_resource_group.demorg.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
}

#Create Azure Web network interface

resource "azurerm_network_interface" "demovmnic" {
  name                = "${local.resource_name_prefix}-webnic"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.demowebsubnet.id
    primary                       = "true"
    name                          = "webvmconfig"
    public_ip_address_id          = azurerm_public_ip.web_linuxvm_publicip.id
  }
}




# Locals Block for custom data
locals {
webvm_custom_data = <<CUSTOM_DATA
#!/bin/sh
#sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd  
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo chmod -R 777 /var/www/html
sudo echo "WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
sudo echo "WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/hostname.html
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install jq -y
sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01"|jq > /var/www/html/metadata.json
CUSTOM_DATA
}


#Create Azure Linux VM

resource "azurerm_linux_virtual_machine" "demowebvm" {
  name = "${local.resource_name_prefix}webvm"
  #computer_name = "${local.resource_name_prefix}-webvm0${count.index}"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  size                = "Standard_B2ms"
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/demo-azure.pub")
  }
   os_disk {
    name = "webvm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
   source_image_reference {
     publisher = "RedHat"
         offer = "RHEL"
           sku = "83-gen2"
       version = "latest"
  }
  network_interface_ids = [ azurerm_network_interface.demovmnic.id]
  custom_data = base64encode(local.webvm_custom_data) 

}



