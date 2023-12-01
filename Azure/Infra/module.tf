module "service_plan" {
  source            = "../../modules/az-service-plan"
  service_plans = try(var.service_plans, {})
}

module "app_insight" {
  source       = "../../modules/az-appinsights"
  app_insights = try(var.app_insights, {})
}

module "app_service" {
  source       = "../../modules/az-appservice"
  app_services = try(var.app_services, {})

  depends_on = [
    module.service_plan,
    module.subnet,
    module.app_config,
    module.app_insight
  ]
}

module "app_config" {
  source       = "../../modules/az-appconfig"
  app_configs = try(var.app_configs, {})
}

module "virtual_network" {
  source           = "../../modules/az-vnet"
  virtual_networks = try(var.virtual_networks, {})
}

module "subnet" {
  source  = "../../modules/az-subnet"
  subnets = try(var.subnets, {})
  depends_on = [
    module.virtual_network
  ]
}

module "private_dns_zone" {
  source      = "../../modules/az-pdns"
  private_dns_zones = try(var.private_dns_zones, {})
  dnszone_vnet_links  = try(var.dnszone_vnet_links, {})
  depends_on = [
    module.subnet
  ]
}

module "mysql_server" {
  source            = "../../modules/az-mysql"
  mysql_servers = var.mysql_servers
  mysql_databases = var.mysql_databases
  depends_on = [
    module.private_dns_zone,
    module.subnet
  ]
}

module "private_endpoint" {
  source            = "../../modules/az-pep"
  providers = {
    azurerm.target = azurerm.target
    azurerm = azurerm
  }
  for_each          = try(var.private_endpoints, {})
  private_endpoints = var.private_endpoints
  config = each.value
  depends_on = [
    module.private_dns_zone,
    module.app_service
  ]
}
