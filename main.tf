resource "azurerm_monitor_autoscale_setting" "monitor_autoscale_setting" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  target_resource_id  = var.target_resource_id
  enabled             = var.enabled
  tags                = var.tags

  dynamic "profile" {
    for_each = var.profiles

    content {
      name = profile.value.name

      capacity {
        default = profile.value.capacity.default
        maximum = profile.value.capacity.maximum
        minimum = profile.value.capacity.minimum
      }
      dynamic "fixed_date" {
        for_each = profile.value.fixed_date == null ? [] : [profile.value.fixed_date]

        content {
          end      = fixed_date.value.end
          start    = fixed_date.value.start
          timezone = try(fixed_date.value.timezone, null)
        }
      }
      dynamic "recurrence" {
        for_each = profile.value.recurrence == null ? [] : [profile.value.recurrence]

        content {
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
          timezone = try(recurrence.value.timezone, null)
        }
      }
      dynamic "rule" {
        for_each = profile.value.rules == null ? {} : profile.value.rules

        content {
          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = coalesce(rule.value.metric_trigger.metric_resource_id, var.target_resource_id)
            operator                 = rule.value.metric_trigger.operator
            statistic                = rule.value.metric_trigger.statistic
            threshold                = rule.value.metric_trigger.threshold
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_grain               = rule.value.metric_trigger.time_grain
            time_window              = rule.value.metric_trigger.time_window
            divide_by_instance_count = try(rule.value.metric_trigger.divide_by_instance_count, null)
            metric_namespace         = try(rule.value.metric_trigger.metric_namespace, null)

            dynamic "dimensions" {
              for_each = rule.value.metric_trigger.dimensions == null ? {} : rule.value.metric_trigger.dimensions

              content {
                name     = dimensions.value.name
                operator = dimensions.value.operator
                values   = dimensions.value.values
              }
            }
          }
          scale_action {
            cooldown  = rule.value.scale_action.cooldown
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
          }
        }
      }
    }
  }
  dynamic "notification" {
    for_each = var.notification == null ? [] : [var.notification]

    content {
      dynamic "email" {
        for_each = notification.value.email == null ? [] : [notification.value.email]

        content {
          custom_emails                         = try(email.value.custom_emails, null)
          send_to_subscription_administrator    = try(email.value.send_to_subscription_administrator, null)
          send_to_subscription_co_administrator = try(email.value.send_to_subscription_co_administrator, null)
        }
      }
      dynamic "webhook" {
        for_each = notification.value.webhooks == null ? {} : notification.value.webhooks

        content {
          service_uri = webhook.value.service_uri
          properties  = try(webhook.value.properties, null)
        }
      }
    }
  }
  dynamic "predictive" {
    for_each = var.predictive == null ? [] : [var.predictive]

    content {
      scale_mode      = predictive.value.scale_mode
      look_ahead_time = try(predictive.value.look_ahead_time, null)
    }
  }
}
