# Create Azure Resource Group

resource "azurerm_resource_group" "demorg" {
  name     =  "${local.resource_name_prefix}-rg"
  location = var.rg_location
}