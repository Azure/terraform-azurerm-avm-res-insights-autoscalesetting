mock_provider "azurerm" {
  mock_data "azurerm_subscription" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}

mock_provider "azapi" {
  mock_data "azapi_resource_list" {
    defaults = {
      output = {
        value = [
          {
            name         = "Standard_D2s_v5"
            resourceType = "virtualMachines"
            restrictions = []
            capabilities = [
              { name = "HyperVGenerations", value = "V1,V2" },
              { name = "vCPUs", value = "2" },
              { name = "EncryptionAtHostSupported", value = "True" },
              { name = "CpuArchitectureType", value = "x64" },
              { name = "PremiumIO", value = "True" },
            ]
          },
          {
            name         = "Standard_D4s_v5"
            resourceType = "virtualMachines"
            restrictions = []
            capabilities = [
              { name = "HyperVGenerations", value = "V1,V2" },
              { name = "vCPUs", value = "4" },
              { name = "EncryptionAtHostSupported", value = "True" },
              { name = "CpuArchitectureType", value = "x64" },
              { name = "PremiumIO", value = "True" },
            ]
          },
          {
            name         = "Standard_B2s"
            resourceType = "virtualMachines"
            restrictions = []
            capabilities = [
              { name = "HyperVGenerations", value = "V1,V2" },
              { name = "vCPUs", value = "2" },
              { name = "EncryptionAtHostSupported", value = "True" },
              { name = "CpuArchitectureType", value = "x64" },
              { name = "PremiumIO", value = "True" },
            ]
          },
          {
            name         = "Standard_D2as_v5"
            resourceType = "virtualMachines"
            restrictions = [{ type = "Location" }]
            capabilities = [
              { name = "HyperVGenerations", value = "V1,V2" },
              { name = "vCPUs", value = "2" },
              { name = "EncryptionAtHostSupported", value = "True" },
              { name = "CpuArchitectureType", value = "x64" },
              { name = "PremiumIO", value = "True" },
            ]
          },
        ]
      }
    }
  }
}

mock_provider "random" {
  mock_resource "random_integer" {
    defaults = { result = 0 }
  }
}

run "selects_eligible_sku_from_azapi_object" {
  command = apply
  providers = {
    azurerm = azurerm
    azapi   = azapi
    random  = random
  }

  variables {
    deployment_region = "eastasia"
  }

  assert {
    condition     = output.sku == "Standard_D2s_v5" && length(local.deploy_skus) == 1 && random_integer.deploy_sku.min == 0 && random_integer.deploy_sku.max == 0
    error_message = "AzAPI's object output must be read directly and retain the existing capacity, capability, restriction, and B-series filters."
  }
}
