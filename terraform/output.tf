output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}
output "storage_account_container_name" {
 value = azurerm_storage_container.tfstate.name
}
output "storage_account_primary_blob_endpoint" {
 value = azurerm_storage_account.tfstate.primary_blob_endpoint
}
