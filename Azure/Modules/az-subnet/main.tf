resource "azurerm_subnet" "subnet" {
  for_each                                       = var.subnets
  name                                           = each.value["name"]
  resource_group_name                            = each.value["resource_group_name"]
  address_prefixes                               = each.value["address_prefixes"]
  virtual_network_name                           = each.value["virtual_network_name"]
  service_endpoints                              = try(each.value["service_endpoints"], null)
  enforce_private_link_endpoint_network_policies = try(each.value["enforce_private_link_endpoint_network_policies"], false)
  enforce_private_link_service_network_policies  = try(each.value["enforce_private_link_service_network_policies"], false)

  lifecycle {
    ignore_changes = [
      # ignore changes to delegation as these seem to happen almost every deployment due to Azure configs
      delegation,
    ]
  }

  dynamic "delegation" {
    for_each = try(each.value.delegation,null)[*]
    content {
      name = delegation.value.name
      service_delegation {
        name = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }

}
