# Create External load balancer to connect

resource "azurerm_public_ip" "demoexternallbip" {
  name              = "${local.resource_name_prefix}_externallbip"
  allocation_method = "Static"
  resource_group_name = azurerm_resource_group.demorg.name
  sku = "Standard"
  domain_name_label = "externallbip"
  location = azurerm_resource_group.demorg.location
}

# Create Azure Load Balancer

resource "azurerm_lb" "externallb" {
  name = "${local.resource_name_prefix}-externallb"
  location = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
  frontend_ip_configuration {
    name = "external-lb-frontend-ip"
    public_ip_address_id = azurerm_public_ip.demoexternallbip.id
 }
 sku = "Standard"
 
}

# Create LB backend pool

resource "azurerm_lb_backend_address_pool" "demoexternallbpool" {
  name = "externallb-backend"
  loadbalancer_id = azurerm_lb.externallb.id
}
# Create LB probe
resource "azurerm_lb_probe" "externallbprobe" {
  name = "externallbprobe"
  loadbalancer_id = azurerm_lb.externallb.id
  port = "80"
  protocol = "Tcp"
  }
# Create LB rule
resource "azurerm_lb_rule" "externallbrule" {
  name = "external-lb-rule"
  protocol = "Tcp"
  frontend_port = "80"
  backend_port = "80"
  frontend_ip_configuration_name = azurerm_lb.externallb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.demoexternallbpool.id ]
  probe_id = azurerm_lb_probe.externallbprobe.id
  loadbalancer_id = azurerm_lb.externallb.id
}


# Associate network interface to Azure web Standard load balancer
resource "azurerm_network_interface_backend_address_pool_association" "webnicasscoclb" {
  count = 2
  network_interface_id = azurerm_network_interface.demovmnic[count.index].id
  ip_configuration_name = azurerm_network_interface.demovmnic[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.demoexternallbpool.id
}
