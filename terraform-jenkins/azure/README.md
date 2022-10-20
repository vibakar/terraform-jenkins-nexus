# Jenkins Deployment for Azure

## Create Service Principal

Instal Azure-Cli(https://docs.microsoft.com/cli/azure/install-azure-cli) and use these 3 easy commands:

```
  az login
  az account set --subscription <Subscription ID>
  az ad sp create-for-rbac
```

By default, the last command creates a Service Principal with the 'Contributor' role scoped to the
current subscription. Pass the '--help' parameter for more info if you want to change the defaults.

## Feature Flag to delete resources groups

*__##Warning## - Do not use this in any environment that contains data you can't afford to use__*

This flag basically will destroy resource groups regardless if the resources aren't part of the TFState. This just makes it an easy cleanup after you've been tinkering with various bits.

```
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.26.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.allows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_id.keyvault](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Username of the admin on the VM | `string` | n/a | yes |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | ID of the service principal | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Password for service principal | `string` | n/a | yes |
| <a name="input_global_id"></a> [global\_id](#input\_global\_id) | Global ID for resource names | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of deployed resource | `string` | n/a | yes |
| <a name="input_public_domain_name"></a> [public\_domain\_name](#input\_public\_domain\_name) | Name of the public domain | `string` | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_ssh_pub_key"></a> [ssh\_pub\_key](#input\_ssh\_pub\_key) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | ID of Azure subscription | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant ID for service principal | `string` | n/a | yes |

## Outputs

No outputs.
