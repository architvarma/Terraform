resource "azurerm_virtual_network" "vnet" {
  for_each            = var.virtual_networks
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value["resourcegroup"]
  address_space       = each.value["address_space"]
  tags                = try(each.value["tags"], null)
}
