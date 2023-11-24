resource "azurerm_mysql_flexible_server" "mysqlserver" {
  for_each              = var.mysql_servers
  name                   = each.value["name"]
  resource_group_name    = each.value["resource_group_name"]
  location               = each.value["location"]
  administrator_login    = try(each.value["administrator_login"],null)
  administrator_password = try(data.azurerm_key_vault_secret.adminpassword[each.key].value,each.value["administrator_password"],null)
  version                = try(each.value["version"],null)
  sku_name               = try(each.value["sku_name"],null)
  zone                   = try(each.value["zone"],null)
  tags                   = try(each.value["tags"], null)
  delegated_subnet_id    = try(data.azurerm_subnet.subnet[each.key].id,null)
  private_dns_zone_id    = try(data.azurerm_private_dns_zone.dnsprivatezone[each.key].id,null)
}

resource "azurerm_mysql_flexible_database" "mysqldb" {
  for_each               = var.mysql_databases
  name                   = each.value["name"]
  resource_group_name    = each.value["resource_group_name"]
  server_name            = each.value["server_name"]
  charset                = each.value["charset"]
  collation              = each.value["collation"]

  depends_on = [
    azurerm_mysql_flexible_server.mysqlserver 
  ]
}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysqlfirewall" {
  for_each            = local.firewall_rules
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
  server_name         = each.value["server_name"]
  start_ip_address    = each.value["start_ip_address"]
  end_ip_address      = each.value["end_ip_address"]

  depends_on = [
    azurerm_mysql_flexible_server.mysqlserver 
  ]
}
