mock_provider "azurerm" {
  mock_resource "azurerm_monitor_autoscale_setting" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.Insights/autoscaleSettings/example"
    }
  }
}

mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}

mock_provider "terraform" {}

variables {
  enable_telemetry    = null
  location            = "eastasia"
  name                = "example"
  resource_group_name = "example"
  target_resource_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.Compute/virtualMachineScaleSets/example"
  profiles = {
    default = {
      name = "default"
      capacity = {
        default = 0
        maximum = 4
        minimum = 0
      }
    }
  }
}

run "defaults_and_scale_to_zero" {
  command = apply
  providers = {
    azurerm   = azurerm
    azapi     = azapi
    terraform = terraform
  }

  assert {
    condition     = output.resource_id == azurerm_monitor_autoscale_setting.monitor_autoscale_setting.id && output.resource_name == "example"
    error_message = "The existing resource address and discrete outputs must remain unchanged."
  }

  assert {
    condition     = output.resource.enabled && output.resource.profile[0].capacity[0].minimum == 0 && output.resource.profile[0].capacity[0].default == 0 && output.resource.profile[0].capacity[0].maximum == 4
    error_message = "Defaults must enable scaling and preserve zero-capacity support."
  }

  assert {
    condition     = length(output.resource.profile[0].rule) == 0 && length(output.resource.notification) == 0 && length(output.resource.predictive) == 0 && length(azapi_resource.telemetry) == 1 && length(terraform_data.telemetry) == 1 && length(data.azapi_client_config.telemetry) == 1
    error_message = "Optional blocks must remain absent while default telemetry is mocked."
  }
}

run "rules_schedules_and_notifications" {
  command = apply
  providers = {
    azurerm   = azurerm
    azapi     = azapi
    terraform = terraform
  }

  variables {
    profiles = {
      recurring = {
        name = "recurring"
        capacity = {
          default = 2
          maximum = 6
          minimum = 1
        }
        recurrence = {
          days    = ["Monday"]
          hours   = [9]
          minutes = [0]
        }
        rules = {
          increase = {
            metric_trigger = {
              metric_name              = "Percentage CPU"
              operator                 = "GreaterThan"
              statistic                = "Average"
              time_aggregation         = "Average"
              time_grain               = "PT1M"
              time_window              = "PT5M"
              threshold                = 80
              divide_by_instance_count = true
              metric_namespace         = "Microsoft.Compute/virtualMachineScaleSets"
              dimensions = {
                instance = {
                  name     = "Instance"
                  operator = "Equals"
                  values   = ["instance1"]
                }
              }
            }
            scale_action = {
              cooldown  = "PT5M"
              direction = "Increase"
              type      = "ChangeCount"
              value     = "2"
            }
          }
        }
      }
      scheduled = {
        name = "scheduled"
        capacity = {
          default = 1
          maximum = 3
          minimum = 0
        }
        fixed_date = {
          start = "2027-01-01T00:00:00Z"
          end   = "2027-01-02T00:00:00Z"
        }
      }
    }
    notification = {
      email = {
        custom_emails                      = ["autoscale@example.com"]
        send_to_subscription_administrator = true
      }
      webhooks = {
        example = {
          service_uri = "https://example.com/autoscale"
          properties  = { environment = "test" }
        }
      }
    }
    predictive = {
      scale_mode      = "ForecastOnly"
      look_ahead_time = "PT5M"
    }
    tags = { environment = "test" }
  }

  assert {
    condition     = length(output.resource.profile) == 2 && one([for p in output.resource.profile : p.recurrence[0].timezone if p.name == "recurring"]) == "UTC" && one([for p in output.resource.profile : p.fixed_date[0].timezone if p.name == "scheduled"]) == "UTC"
    error_message = "Both schedule types and their default timezones must be preserved."
  }

  assert {
    condition     = one([for p in output.resource.profile : p.rule[0].metric_trigger[0].metric_resource_id if p.name == "recurring"]) == var.target_resource_id && one([for p in output.resource.profile : p.rule[0].metric_trigger[0].dimensions[0].values[0] if p.name == "recurring"]) == "instance1" && one([for p in output.resource.profile : p.rule[0].scale_action[0].value if p.name == "recurring"]) == 2
    error_message = "The target fallback, dimensions, and scaling action must remain wired."
  }

  assert {
    condition     = output.resource.notification[0].email[0].send_to_subscription_administrator && output.resource.notification[0].webhook[0].service_uri == "https://example.com/autoscale" && output.resource.predictive[0].scale_mode == "ForecastOnly" && output.resource.tags.environment == "test"
    error_message = "Email, webhook, predictive settings, and tags must remain wired."
  }
}

run "disabled_scaling_and_telemetry" {
  command = apply
  providers = {
    azurerm   = azurerm
    azapi     = azapi
    terraform = terraform
  }

  variables {
    enabled          = false
    enable_telemetry = false
  }

  assert {
    condition     = !output.resource.enabled && length(azapi_resource.telemetry) == 0 && length(terraform_data.telemetry) == 0 && length(data.azapi_client_config.telemetry) == 0
    error_message = "Disabling scaling must preserve the setting and disabling telemetry must create no telemetry instances."
  }
}
