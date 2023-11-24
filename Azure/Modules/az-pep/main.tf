resource "azurerm_private_endpoint" "pep" {
  provider            = azurerm.target
  name                = var.config["name"]
  location            = var.config["location"]
  resource_group_name = var.config["resource_group_name"]
  subnet_id           = data.azurerm_subnet.subnet.id
  tags                = try(var.config["tags"], null)

  private_service_connection {
    name                           = var.config["private_service_connection_name"]
    private_connection_resource_id = try(local.private_connection_resource_id,null)
    is_manual_connection           = var.config["is_manual_connection"]
    subresource_names              = try(var.config["subresource_names"], null)
  }

  dynamic "ip_configuration" {
    for_each = try(var.config.ip_configuration, null)[*]
    content {
      name                 = ip_configuration.value["ip_config_name"]
      private_ip_address   = ip_configuration.value["private_ip_address"]
    }
  }

  dynamic "private_dns_zone_group" {
    for_each = try(var.config.private_dns_zone_group, {})
    content {
      name                 = try(private_dns_zone_group.value.name, null)
      private_dns_zone_ids = [data.azurerm_private_dns_zone.dnsprivatezone.id]
    }
  }
}
