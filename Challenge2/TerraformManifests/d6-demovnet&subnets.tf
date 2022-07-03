# This is used to created Vnet and multiple subnets (web,app and DB , Bastion Subnet)

resource "azurerm_virtual_network" "demovnet" {
  name                 = "${local.resource_name_prefix}-vnet"
  location             = azurerm_resource_group.demorg.location
  resource_group_name  = azurerm_resource_group.demorg.name
  address_space        = var.vnet_addressspace
}
resource "azurerm_subnet" "demowebsubnet" {
  name                 = "${local.resource_name_prefix}-websubnet"
  virtual_network_name = azurerm_virtual_network.demovnet.name
  resource_group_name  = azurerm_resource_group.demorg.name
  address_prefixes     = var.Web_subnet_addressspace
}

resource "azurerm_network_security_group" "demowebnsg" {
  name                    = "websubnetnsg"
  resource_group_name     = azurerm_resource_group.demorg.name
  location                = azurerm_resource_group.demorg.location

}

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

