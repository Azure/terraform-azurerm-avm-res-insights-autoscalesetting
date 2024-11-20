variable "location" {
  type        = string
  description = <<DESCRIPTION
(Required) Specifies the supported Azure location where the AutoScale Setting should exist. Changing this forces a new resource to be created.
DESCRIPTION
  nullable    = false
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
(Required) The name of the AutoScale Setting. Changing this forces a new resource to be created.
DESCRIPTION
  nullable    = false
}

variable "profiles" {
  type = map(object({
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
  description = <<DESCRIPTION
(Required) A map of profiles to associate to the AutoScale Setting. Specifies one or more (up to 20).
- `name` - (Required) Specifies the name of the profile.
- `capacity` - (Required) A capacity block as defined below.
  - `default` - (Required) The number of instances that are available for scaling if metrics are not available for evaluation. The default is only used if the current instance count is lower than the default. Valid values are between 0 and 1000.
  - `maximum` - (Required) The maximum number of instances for this resource. Valid values are between 0 and 1000.
  - `minimum` - (Required) The minimum number of instances for this resource. Valid values are between 0 and 1000.
- `rules` - (Optional) One or more (up to 10) rule blocks as defined below.
  - `metric_trigger` - (Required) A metric_trigger block as defined below.
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
  - `scale_action` - (Required) A scale_action block as defined below.
    - `cooldown` - (Required) The amount of time to wait since the last scaling action before this action occurs. Must be between 1 minute and 1 week and formatted as a ISO 8601 string.
    - `direction` - (Required) The scale direction. Possible values are Increase and Decrease.
    - `type` - (Required) The type of action that should occur. Possible values are ChangeCount, ExactCount, PercentChangeCount and ServiceAllowedNextValue.
    - `value` - (Required) The number of instances involved in the scaling action.
- `fixed_date` - (Optional) A fixed_date block as defined below. This cannot be specified if a recurrence block is specified.
  - `end` - (Required) Specifies the end date for the profile, formatted as an RFC3339 date string.
  - `start` - (Required) Specifies the start date for the profile, formatted as an RFC3339 date string.
  - `timezone` - (Optional) The Time Zone of the start and end times. Defaults to UTC.
- `recurrence` - (Optional) A recurrence block as defined below. This cannot be specified if a fixed_date block is specified.
  - `timezone` - (Optional) The Time Zone used for the hours field. Defaults to UTC.
  - `days` - (Required) A list of days that this profile takes effect on. Possible values include Monday, Tuesday, Wednesday, Thursday, Friday, Saturday and Sunday.
  - `hours` - (Required) A list containing a single item, which specifies the Hour interval at which this recurrence should be triggered (in 24-hour time). Possible values are from 0 to 23.
  - `minutes` - (Required) A list containing a single item which specifies the Minute interval at which this recurrence should be triggered.
DESCRIPTION
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
(Required) The name of the Resource Group in the AutoScale Setting should be created. Changing this forces a new resource to be created.
DESCRIPTION
  nullable    = false
}

variable "target_resource_id" {
  type        = string
  description = <<DESCRIPTION
(Required) Specifies the resource ID of the resource that the autoscale setting should be added to. Changing this forces a new resource to be created.
DESCRIPTION
  nullable    = false
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
(Optional) Specifies whether automatic scaling is enabled for the target resource. Defaults to true.
DESCRIPTION
  nullable    = false
}

variable "notification" {
  type = object({
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
  default     = null
  description = <<DESCRIPTION
(Optional) A notification block associated to autoscale setting. Defaults to null.
- `email` - (Optional) A email block as defined below.
  - `send_to_subscription_administrator` - (Optional) Should email notifications be sent to the subscription administrator? Defaults to false.
  - `send_to_subscription_co_administrator` - (Optional) Should email notifications be sent to the subscription co-administrator? Defaults to false.
  - `custom_emails` - (Optional) Specifies a list of custom email addresses to which the email notifications will be sent.
- `webhook` - (Optional) One or more webhook blocks as defined below.
  - `service_uri` - (Required) The HTTPS URI which should receive scale notifications.
  - `properties` - (Optional) A map of settings.
DESCRIPTION
}

variable "predictive" {
  type = object({
    scale_mode      = string
    look_ahead_time = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
(Optional) A predictive block associated to autoscale setting. Defaults to null.
- `scale_mode` - (Required) Specifies the predictive scale mode. Possible values are Enabled or ForecastOnly.
- `look_ahead_time` - (Optional) Specifies the amount of time by which instances are launched in advance. It must be between PT1M and PT1H in ISO 8601 format.
DESCRIPTION
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
