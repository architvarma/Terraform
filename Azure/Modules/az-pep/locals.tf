locals {
  private_connection_resource_id = "${try(var.config.app_service_name,null) != null ? data.azurerm_app_service.app_service[0].id : null}"
}
