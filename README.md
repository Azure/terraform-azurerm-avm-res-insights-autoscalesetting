<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is a template repo for Terraform Azure Verified Modules.

Things to do:

1. Set up a GitHub repo environment called `test`.
1. Configure environment protection rule to ensure that approval is required before deploying to this environment.
1. Create a user-assigned managed identity in your test subscription.
1. Create a role assignment for the managed identity on your test subscription, use the minimum required role.
1. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.
1. Search and update TODOs within the code and remove the TODO comments once complete.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.116, < 5)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_monitor_autoscale_setting.monitor_autoscale_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: (Required) Specifies the supported Azure location where the AutoScale Setting should exist. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: (Required) The name of the AutoScale Setting. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_profiles"></a> [profiles](#input\_profiles)

Description: (Required) A map of profiles to associate to the AutoScale Setting. Specifies one or more (up to 20).
- `name` - (Required) Specifies the name of the profile.
- `capacity` - (Required) A capacity block as defined below.
  - `default` - (Required) The number of instances that are available for scaling if metrics are not available for evaluation. The default is only used if the current instance count is lower than the default. Valid values are between 0 and 1000.
  - `maximum` - (Required) The maximum number of instances for this resource. Valid values are between 0 and 1000.
  - `minimum` - (Required) The minimum number of instances for this resource. Valid values are between 0 and 1000.
- `rules` - (Optional) One or more (up to 10) rule blocks as defined below.
  - `metric_trigger` - (Required) A metric\_trigger block as defined below.
    - `metric_name` - (Required) The name of the metric that defines what the rule monitors, such as Percentage CPU for Virtual Machine Scale Sets and CpuPercentage for App Service Plan.
    - `metric_resource_id` - (Optional) The ID of the Resource which the Rule monitors.
    - `operator` - (Required) Specifies the operator used to compare the metric data and threshold. Possible values are: Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual.
    - `statistic` - (Required) Specifies how the metrics from multiple instances are combined. Possible values are Average, Max, Min and Sum.
    - `time_aggregation` - (Required) Specifies how the data that's collected should be combined over time. Possible values include Average, Count, Maximum, Minimum, Last and Total.
    - `time_grain` - (Required) Specifies the granularity of metrics that the rule monitors, which must be one of the pre-defined values returned from the metric definitions for the metric. This value must be between 1 minute and 12 hours an be formatted as an ISO 8601 string.
    - `time_window` - (Required) Specifies the time range for which data is collected, which must be greater than the delay in metric collection (which varies from resource to resource). This value must be between 5 minutes and 12 hours and be formatted as an ISO 8601 string.
    - `threshold` - (Required) Specifies the threshold of the metric that triggers the scale action.
    - `metric_namespace` - (Optional) The namespace of the metric that defines what the rule monitors, such as microsoft.compute/virtualmachinescalesets for Virtual Machine Scale Sets.
    - `dimensions` - (Optional) One or more dimensions block as defined below.
      - `name` - (Required) The name of the dimension.
      - `operator` - (Required) The dimension operator. Possible values are Equals and NotEquals. Equals means being equal to any of the values. NotEquals means being not equal to any of the values.
      - `values` - (Required) A list of dimension values.
    - `divide_by_instance_count` - (Optional) Whether to enable metric divide by instance count.
  - `scale_action` - (Required) A scale\_action block as defined below.
    - `cooldown` - (Required) The amount of time to wait since the last scaling action before this action occurs. Must be between 1 minute and 1 week and formatted as a ISO 8601 string.
    - `direction` - (Required) The scale direction. Possible values are Increase and Decrease.
    - `type` - (Required) The type of action that should occur. Possible values are ChangeCount, ExactCount, PercentChangeCount and ServiceAllowedNextValue.
    - `value` - (Required) The number of instances involved in the scaling action.
- `fixed_date` - (Optional) A fixed\_date block as defined below. This cannot be specified if a recurrence block is specified.
  - `end` - (Required) Specifies the end date for the profile, formatted as an RFC3339 date string.
  - `start` - (Required) Specifies the start date for the profile, formatted as an RFC3339 date string.
  - `timezone` - (Optional) The Time Zone of the start and end times. Defaults to UTC.
- `recurrence` - (Optional) A recurrence block as defined below. This cannot be specified if a fixed\_date block is specified.
  - `timezone` - (Optional) The Time Zone used for the hours field. Defaults to UTC.
  - `days` - (Required) A list of days that this profile takes effect on. Possible values include Monday, Tuesday, Wednesday, Thursday, Friday, Saturday and Sunday.
  - `hours` - (Required) A list containing a single item, which specifies the Hour interval at which this recurrence should be triggered (in 24-hour time). Possible values are from 0 to 23.
  - `minutes` - (Required) A list containing a single item which specifies the Minute interval at which this recurrence should be triggered.

Type:

```hcl
map(object({
    name = string
    capacity = object({
      default = number
      maximum = number
      minimum = number
    })
    rules = optional(map(object({
      metric_trigger = object({
        metric_name        = string
        metric_resource_id = optional(string)
        operator           = string
        statistic          = string
        time_aggregation   = string
        time_grain         = string
        time_window        = string
        threshold          = number
        metric_namespace   = optional(string)
        dimensions = optional(map(object({
          name     = string
          operator = string
          values   = list(string)
        })))
        divide_by_instance_count = optional(bool)
      })
      scale_action = object({
        cooldown  = string
        direction = string
        type      = string
        value     = string
      })
    })))
    fixed_date = optional(object({
      end      = string
      start    = string
      timezone = optional(string, "UTC")
    }))
    recurrence = optional(object({
      timezone = optional(string, "UTC")
      days     = list(string)
      hours    = list(number)
      minutes  = list(number)
    }))
  }))
```

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: (Required) The name of the Resource Group in the AutoScale Setting should be created. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id)

Description: (Required) Specifies the resource ID of the resource that the autoscale setting should be added to. Changing this forces a new resource to be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.

Type:

```hcl
object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
```

Default: `null`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: (Optional) Specifies whether automatic scaling is enabled for the target resource. Defaults to true.

Type: `bool`

Default: `true`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description: Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_notification"></a> [notification](#input\_notification)

Description: (Optional) A notification block associated to autoscale setting. Defaults to null.
- `email` - (Optional) A email block as defined below.
  - `send_to_subscription_administrator` - (Optional) Should email notifications be sent to the subscription administrator? Defaults to false.
  - `send_to_subscription_co_administrator` - (Optional) Should email notifications be sent to the subscription co-administrator? Defaults to false.
  - `custom_emails` - (Optional) Specifies a list of custom email addresses to which the email notifications will be sent.
- `webhook` - (Optional) One or more webhook blocks as defined below.
  - `service_uri` - (Required) The HTTPS URI which should receive scale notifications.
  - `properties` - (Optional) A map of settings.

Type:

```hcl
object({
    email = optional(object({
      send_to_subscription_administrator    = optional(bool, false)
      send_to_subscription_co_administrator = optional(bool, false)
      custom_emails                         = optional(list(string), [])
    }))
    webhooks = optional(map(object({
      service_uri = string
      properties  = optional(map(string), {})
    })))
  })
```

Default: `null`

### <a name="input_predictive"></a> [predictive](#input\_predictive)

Description: (Optional) A predictive block associated to autoscale setting. Defaults to null.
- `scale_mode` - (Required) Specifies the predictive scale mode. Possible values are Enabled or ForecastOnly.
- `look_ahead_time` - (Optional) Specifies the amount of time by which instances are launched in advance. It must be between PT1M and PT1H in ISO 8601 format.

Type:

```hcl
object({
    scale_mode      = string
    look_ahead_time = optional(string)
  })
```

Default: `null`

### <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints)

Description: A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.

Type:

```hcl
map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
```

Default: `{}`

### <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group)

Description: Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy.

Type: `bool`

Default: `true`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: All attributes of the Monitor Autoscale Setting resource.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: The ID of the Monitor Autoscale Setting.

### <a name="output_resource_name"></a> [resource\_name](#output\_resource\_name)

Description: The name of the Monitor Autoscale Setting.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->