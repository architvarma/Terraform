resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each            = var.private_dns_zones
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
  tags                = try(each.value["tags"], null)
}

resource "azurerm_private_dns_zone_virtual_network_link" "dsnzone_vnet_link" {
  for_each = {
    for k,v in try(var.dnszone_vnet_links, {}) : k => v
  }
  name                  = each.value["name"]
  resource_group_name   = each.value["resource_group_name"]
  private_dns_zone_name = each.value["private_dns_zone_name"]
  virtual_network_id    = data.azurerm_virtual_network.vnet[each.key].id
  registration_enabled  = try(each.value["registration_enabled"], null)
  tags                  = try(each.value["tags"], null)
  depends_on = [
    azurerm_private_dns_zone.private_dns_zone
  ]
}
