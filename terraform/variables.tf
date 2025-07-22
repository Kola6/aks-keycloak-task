variable "resource_group_name" { default = "keycloak-aks-rg" }
variable "location" { default = "East US" }
variable "vnet_name" { default = "keycloak-vnet" }
variable "vnet_address_space" { default = ["10.10.0.0/16"] }
variable "subnet_name" { default = "keycloak-subnet" }
variable "subnet_address_prefixes" { default = ["10.10.1.0/24"] }
variable "aks_name" { default = "keycloak-aks" }
variable "aks_dns_prefix" { default = "keycloakaks" }
variable "default_node_pool_name" { default = "default" }
variable "default_node_count" { default = 2 }
variable "default_vm_size" { default = "Standard_B2s" }
variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    project     = "keycloak-aks"
  }
}
variable "storage_account_name" { default = "keycloakstoac12" }
variable "storage_account_container_name" { default = "tfstate" }
