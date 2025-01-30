<!-- BEGIN_TF_DOCS -->
# terraform-avm-res-insights-autoscalesetting

This is an AVM module for terraform-avm-res-insights-autoscalesetting. It manages an AutoScale Setting which can be applied to Virtual Machine Scale Sets, App Services and other scalable resources.

This module *DOES NOT* create Virtual Machine Scale Sets, App Services or other scalable resource, but provides the autoscale settings that can be applied to these resources.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

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