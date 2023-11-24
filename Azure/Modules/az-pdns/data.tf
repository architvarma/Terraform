data "azurerm_virtual_network" "vnet" {
    for_each = {
        for k,v in try(var.dnszone_vnet_links, {}) : k => v
    }
    name                = each.value["virtual_network_name"]
    resource_group_name = each.value["virtual_network_rg"]
}
