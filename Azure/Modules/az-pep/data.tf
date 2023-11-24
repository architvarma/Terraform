data "azurerm_subnet" "subnet" {
  provider             = azurerm.target
  name                 = try(var.config["subnet_name"],null)
  virtual_network_name = try(var.config["virtual_network_name"],null)
  resource_group_name  = try(var.config["virtual_network_rg"],null)
}

data "azurerm_app_service" "app_service" {
  count = var.config.subresource_names == ["sites"] ? 1 : 0
  provider = azurerm
  name                = try(var.config["app_service_name"],null)
  resource_group_name = try(var.config["app_service_rg"],null)
}

data "azurerm_private_dns_zone" "dnsprivatezone" {
  provider            = azurerm.target
  name                = try(var.config["pdns_zone_name"],null)
  resource_group_name = try(var.config["resource_group_name"],null)
}
