# Create External load balancer to connect

resource "azurerm_public_ip" "bastionip" {
  name              = "${local.resource_name_prefix}_bastionpublicip"
  allocation_method = "Static"
  resource_group_name = azurerm_resource_group.demorg.name
  sku = "Standard"
  domain_name_label = "bastionlbip"
  location = azurerm_resource_group.demorg.location
}

resource "azurerm_network_interface" "bastionvmnic" {
  
  name                = "${local.resource_name_prefix}-bastionnic"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
  ip_configuration {
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.demobastionsubnet.id
    primary = "true"
    public_ip_address_id = azurerm_public_ip.bastionip.id
    name = "bastionvmconfig"
  }
}

#Create Azure Linux VM

resource "azurerm_linux_virtual_machine" "bastionvm" {
  name = "${local.resource_name_prefix}-bastionvm"
  #computer_name = "${local.resource_name_prefix}-appvm0${count.index}"
  resource_group_name = azurerm_resource_group.demorg.name
  location = azurerm_resource_group.demorg.location
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/demo-azure.pub")
  }
   os_disk {
    name = "bastionvm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
   source_image_reference {
     publisher = "RedHat"
         offer = "RHEL"
           sku = "83-gen2"
       version = "latest"
  }
  network_interface_ids = [ azurerm_network_interface.bastionvmnic.id]
}


# Create a Null Resource and Provisioners
resource "null_resource" "copysshkeytobastionvm" {
  depends_on = [azurerm_linux_virtual_machine.bastionvm]
# Connection Block for Provisioners to connect to Azure VM Instance
  connection {
    type = "ssh"
    host = azurerm_linux_virtual_machine.bastionvm.public_ip_address
    user = azurerm_linux_virtual_machine.bastionvm.admin_username
    private_key = file("${path.module}/ssh-keys/demo-azure.pem")
  }
## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source = "ssh-keys/demo-azure.pem"
    destination = "/tmp/demo-azure.pem"
  }
## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/demo-azure.pem"
    ]
  }
}