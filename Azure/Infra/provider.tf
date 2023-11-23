provider "azurerm" {
    features {
        key_vault {
            purge_soft_delete_on_destroy = true
        }
    }
    skip_provider_registration = "true"
    version                    = "3.43.0"
}

provider "azurerm" {
    alias = "target"
    subscription_id = "{your-azure-subscription-id}"
    features {
        key_vault {
            purge_soft_delete_on_destroy = true
        }
    }
    skip_provider_registration = "true"
    version                    = "3.43.0"
}


terraform {
    backend "azurerm" {}
}
