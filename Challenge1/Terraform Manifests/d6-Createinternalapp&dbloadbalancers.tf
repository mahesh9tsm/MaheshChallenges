# Create Internal Load Balancer for DB and APP, Application gateway for Web 

resource "azurerm_lb" "demoapplb" {
  name = "${local.resource_name_prefix}-applb"
  resource_group_name = azurerm_resource_group.demorg.name
  location = azurerm_resource_group.demorg.location
  sku = "Standard"
  frontend_ip_configuration {
    name = "appfrontend"
    subnet_id = azurerm_subnet.demoappsubnet.id
    private_ip_address_allocation = "Dynamic" 
  }
}

resource "azurerm_lb_backend_address_pool" "demoapplb_addresspool" {
  name = "app-backend"
  loadbalancer_id = azurerm_lb.demoapplb.id
}

resource "azurerm_lb_probe" "demoapprobe" {
  name = "tcpprobe"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.demoapplb.id
  #resource_group_name = azurerm_resource_group.demorg.name
}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "demoapplbrule" {
  name                           = "demo-app-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.demoapplb.frontend_ip_configuration[0].name
  backend_address_pool_ids        = [ azurerm_lb_backend_address_pool.demoapplb_addresspool.id ]
  probe_id                       = azurerm_lb_probe.demoapprobe.id
  loadbalancer_id                = azurerm_lb.demoapplb.id
  #resource_group_name            = azurerm_resource_group.demorg.name
}


# Associate netwokr interface toAzure web Standard load balancer
resource "azurerm_network_interface_backend_address_pool_association" "appnicassoclb" {
  count = 2
  network_interface_id = azurerm_network_interface.appvmnic[count.index].id
  ip_configuration_name = azurerm_network_interface.appvmnic[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.demoapplb_addresspool.id
}

############################################ Create Internal Load Balancer for DB Tier ##############################

resource "azurerm_lb" "demodblb" {
  name = "${local.resource_name_prefix}-dblb"
  resource_group_name = azurerm_resource_group.demorg.name
  location = azurerm_resource_group.demorg.location
  sku = "Standard"
  frontend_ip_configuration {
    name = "dbfrontend"
    subnet_id = azurerm_subnet.demodbsubnet.id
    #private_ip_address = "10.0.3.12"
    private_ip_address_allocation = "Dynamic" 
  }
}

resource "azurerm_lb_backend_address_pool" "demodblb_addresspool" {
  name = "db-backend"
  loadbalancer_id = azurerm_lb.demodblb.id
}

resource "azurerm_lb_probe" "demodbrobe" {
  name = "tcpprobe"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.demodblb.id
  #resource_group_name = azurerm_resource_group.demorg.name
}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "demodblbrule" {
  name                           = "demo-db-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.demodblb.frontend_ip_configuration[0].name
  backend_address_pool_ids        = [ azurerm_lb_backend_address_pool.demodblb_addresspool.id ]
  probe_id                       = azurerm_lb_probe.demodbrobe.id
  loadbalancer_id                = azurerm_lb.demodblb.id
  #resource_group_name            = azurerm_resource_group.demorg.name
}

# Associate netwokr interface toAzure web Standard load balancer
resource "azurerm_network_interface_backend_address_pool_association" "dbnicassoclb" {
  count = 2
  network_interface_id = azurerm_network_interface.dbvmnic[count.index].id
  ip_configuration_name = azurerm_network_interface.dbvmnic[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.demodblb_addresspool.id
}
