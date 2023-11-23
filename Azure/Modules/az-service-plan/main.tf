resource "azurerm_service_plan" "appserviceplan" {
    for_each                        = var.service_plans
    name                            = each.value["plan_name"]
    location                        = each.value["plan_location"]
    resource_group_name             = each.value["plan_rg"]
    os_type                         = try(each.value.os_type, "Windows")
    sku_name                        = each.value["sku_name"]
    maximum_elastic_worker_count    = try(each.value["maximum_elastic_worker_count"],null)
    per_site_scaling_enabled        = try(each.value["per_site_scaling_enabled"],null)
    zone_balancing_enabled          = try(each.value["zone_balancing_enabled"],null)
    worker_count                    = try(each.value["worker_count"],null)
    tags                            = try(each.value.tags, null)
}
