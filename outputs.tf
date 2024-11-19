# output "private_endpoints" {
#   description = <<DESCRIPTION
#   A map of the private endpoints created.
#   DESCRIPTION
#   value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
# }


output "resource" {
  description = "All attributes of the Monitor Autoscale Setting resource."
  value       = azurerm_monitor_autoscale_setting.monitor_autoscale_setting
}

output "resource_id" {
  description = "The ID of the Monitor Autoscale Setting."
  value       = azurerm_monitor_autoscale_setting.monitor_autoscale_setting.id
}

output "resource_name" {
  description = "The name of the Monitor Autoscale Setting."
  value       = azurerm_monitor_autoscale_setting.monitor_autoscale_setting.name
}
