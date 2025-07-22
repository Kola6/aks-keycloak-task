terraform {
  backend "azurerm" {
    resource_group_name  = "keycloak-aks-task-rg"
    storage_account_name = "keycloakstoac12"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}