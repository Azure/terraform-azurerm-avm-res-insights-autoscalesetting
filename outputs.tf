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
