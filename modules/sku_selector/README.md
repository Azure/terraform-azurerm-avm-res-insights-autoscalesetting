<!-- BEGIN_TF_DOCS -->
# Sku Selector Sub-Module

This sku selector sub-module was implemented to help minimize the number of example test deployment failures due to restrictions on different skus in different regions for testing. This is not intended to be a part of the main module and is just a helper module for testing.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.13, != 1.13.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.116.0, < 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Resources

The following resources are used by this module:

- [random_integer.deploy_sku](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [azapi_resource_list.example](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/resource_list) (data source)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_deployment_region"></a> [deployment\_region](#input\_deployment\_region)

Description: The selected region for deployment

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Dummy variable to meet linting requirements

### <a name="output_sku"></a> [sku](#output\_sku)

Description: sku

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->