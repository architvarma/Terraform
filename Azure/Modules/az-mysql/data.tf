data "azurerm_subnet" "subnet" {
    for_each = {
        for k,v in try(var.mysql_servers, {}) : k => v
        if try(v.subnet_name, null) != null && try(v.virtual_network_name, null) != null
    }
    name                 = try(each.value["subnet_name"],null)
    virtual_network_name = try(each.value["virtual_network_name"],null)
    resource_group_name  = try(each.value["virtual_network_rg"],null)
}

data "azurerm_private_dns_zone" "dnsprivatezone" {
    for_each = {
        for k,v in try(var.mysql_servers, {}) : k => v
        if try(v.pdns_zone_name, null) != null
    }
    name                = try(each.value["pdns_zone_name"],null)
    resource_group_name = try(each.value["resource_group_name"],null)
}

data "azurerm_key_vault" "kv" {
  for_each = {
      for k,v in try(var.mysql_servers, {}) : k => v
      if try(v.key_vault_name, null) != null
  }
  name                = each.value ["key_vault_name"]
  resource_group_name = each.value ["resource_group_name"]
}

data "azurerm_key_vault_secret" "adminpassword" {
  for_each = {
      for k,v in try(var.mysql_servers, {}) : k => v
      if try(v.administrator_password_secret_name, null) != null
  }
  name         = each.value ["administrator_password_secret_name"]
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}
