# Get the output values from the Azure Services Created

output "internalapploadbalancer" {
  value = azurerm_lb.demoapplb.id
  }

output "internalapploadbalancerip" {
  value = azurerm_lb.demoapplb.private_ip_address
  }

output "internaldbloadbalancer" {
  value = azurerm_lb.demodblb.id
  }

output "internaldbloadbalancerip" {
  value = azurerm_lb.demodblb.private_ip_address
  }

output "externaldbloadbalancer" {
  value = azurerm_lb.externallb.id
  }

output "externaldbloadbalancerpublicipid" {
  value = azurerm_lb.externallb.frontend_ip_configuration[0].public_ip_address_id
  }

output "externaldbloadbalancerpublicip" {
  value = azurerm_public_ip.demoexternallbip.ip_address
  }

  


