# This is used to created Vnet and multiple subnets (web,app and DB , Bastion Subnet)

#Create Azure Virtual Network 

resource "azurerm_virtual_network" "demovnet" {
  name                 = "${local.resource_name_prefix}-vnet"
  location             = azurerm_resource_group.demorg.location
  resource_group_name  = azurerm_resource_group.demorg.name
  address_space        = var.vnet_addresspace
}

#Create Azure web Subnet 

resource "azurerm_subnet" "demowebsubnet" {
  name                 = "${local.resource_name_prefix}-websubnet"
  virtual_network_name = azurerm_virtual_network.demovnet.name
  resource_group_name  = azurerm_resource_group.demorg.name
  address_prefixes     = var.Web_subnet_addressspace
}

#Create Azure web network security group

resource "azurerm_network_security_group" "demowebnsg" {
  name                    = "websubnetnsg"
  resource_group_name     = azurerm_resource_group.demorg.name
  location                = azurerm_resource_group.demorg.location

}

# Associate web network security group to web subnet

resource "azurerm_subnet_network_security_group_association" "demowebnsgassoc" {
  depends_on                = [azurerm_network_security_group.demowebnsg]
  subnet_id                 = azurerm_subnet.demowebsubnet.id
  network_security_group_id = azurerm_network_security_group.demowebnsg.id

}



#locals block for web Security rules
locals {
   web_inbound_ports_map = {
     "100" : "80" 
     "120" : "443"
     "140" : "22"
    }
}

resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
  for_each = local.web_inbound_ports_map
  name                        = "Rule-port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demorg.name
  network_security_group_name = azurerm_network_security_group.demowebnsg.name

}

#Create Azure app Subnet 

resource "azurerm_subnet" "demoappsubnet" {
  name                 = "${local.resource_name_prefix}-appsubnet"
  virtual_network_name = azurerm_virtual_network.demovnet.name
  resource_group_name  = azurerm_resource_group.demorg.name
  address_prefixes     = var.App_subnet_addressspace
}

# Create APP NSG and Security rules

resource "azurerm_network_security_group" "demoappnsg" {
  name                = "appsubnetnsg"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
}

# Associate app network security group to app subnet

resource "azurerm_subnet_network_security_group_association" "demoappnsgassoc" {
  depends_on                = [azurerm_network_security_group.demoappnsg]
  subnet_id                 = azurerm_subnet.demoappsubnet.id
  network_security_group_id = azurerm_network_security_group.demoappnsg.id

}

# Local block for Security Rules for Web,APP, DB and Bastion

#locals block for demo Security rules
locals {
   app_inbound_ports_map = {
     "100" : "80" 
     "120" : "443"
     "140" : "22"
    }
}

resource "azurerm_network_security_rule" "app_nsg_rule_inbound" {
  for_each                    = local.app_inbound_ports_map
  name                        = "Rule-port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demorg.name
  network_security_group_name = azurerm_network_security_group.demoappnsg.name

}


#Create Azure DB Subnet 

resource "azurerm_subnet" "demodbsubnet" {
  name                 = "${local.resource_name_prefix}-dbsubnet"
  virtual_network_name = azurerm_virtual_network.demovnet.name
  resource_group_name  = azurerm_resource_group.demorg.name
  address_prefixes     = var.Db_subnet_addressspace
}

# Create DB NSG and Security rules

resource "azurerm_network_security_group" "demodbnsg" {
  name                = "dbsubnetnsg"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
}

# Associate db network security group to db subnet

resource "azurerm_subnet_network_security_group_association" "demodbnsgassoc" {
  depends_on                = [azurerm_network_security_group.demodbnsg]
  subnet_id                 = azurerm_subnet.demodbsubnet.id
  network_security_group_id = azurerm_network_security_group.demodbnsg.id

}

# Local block for Security Rules for Web,APP, DB and Bastion

#locals block for db Security rules
locals {
   db_inbound_ports_map = {
    "100" : "3306" 
    "110" : "1433"
    "120" : "5432"
    }
}



resource "azurerm_network_security_rule" "db_nsg_rule_inbound" {
  for_each = local.db_inbound_ports_map
  name                        = "Rule-port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demorg.name
  network_security_group_name = azurerm_network_security_group.demodbnsg.name

}

#Create Bastion Subnet

resource "azurerm_subnet" "demobastionsubnet" {
  name                 = "${local.resource_name_prefix}-bastionsubnet"
  virtual_network_name = azurerm_virtual_network.demovnet.name
  resource_group_name  = azurerm_resource_group.demorg.name
  address_prefixes     = var.Bastion_subnet_addressspace
}


# Create bastion NSG and Security rules

resource "azurerm_network_security_group" "demobastionnsg" {
  name                = "bastionsubnetnsg"
  resource_group_name = azurerm_resource_group.demorg.name
  location            = azurerm_resource_group.demorg.location
}

#Associate Bastion NSG to Bastion Subnet

resource "azurerm_subnet_network_security_group_association" "demobastionnsgassoc" {
  depends_on                = [azurerm_network_security_group.demobastionnsg]
  subnet_id                 = azurerm_subnet.demobastionsubnet.id
  network_security_group_id = azurerm_network_security_group.demobastionnsg.id

}

# Local block for Security Rules for Web,APP, DB and Bastion

#locals block for demo Security rules
locals {
   bastion_inbound_ports_map = {
     "150" : "3389"
     "140" : "22"
   
    }
}

resource "azurerm_network_security_rule" "bastion_nsg_rule_inbound" {
  for_each = local.bastion_inbound_ports_map
  name                        = "Rule-port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.demorg.name
  network_security_group_name = azurerm_network_security_group.demobastionnsg.name
 }


 