# Module to create an Azure Backup for Virtual Machines, datadisks and storage account containers (File Share)

## Changelog
Initial setup

## Requirements

| Name | Version |
|------|---------|
| [terraform](#requirement\_terraform) | >= 1.0.0 |
| [azurerm](#requirement\_azurerm) | >= 3.0.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| [azurerm](#provider\_azurerm) | 3.82.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_container_storage_account.backup_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_container_storage_account) | resource |
| [azurerm_backup_policy_file_share.policy_fs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share) | resource |
| [azurerm_backup_policy_vm.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |
| [azurerm_backup_protected_file_share.backup_fs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_file_share) | resource |
| [azurerm_backup_protected_vm.protected_vms](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_recovery_services_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) | resource |
| [azurerm_storage_share.storage_share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_account.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [backup\_config](#input\_backup\_config) | Configures the Policy backup frequency and times | ```list(object({ frequency = string time = string }))``` | ```[ { "frequency": "Daily", "time": "23:00" } ]``` | no |
| [create\_file\_share\_policy](#input\_create\_file\_share\_policy) | Set to true to create a file share policy. | `bool` | `true` | no |
| [file\_share\_policy\_name](#input\_file\_share\_policy\_name) | Name for the file share policy. | `string` | `null` | no |
| [location](#input\_location) | The location where the resource group is located. | `string` | `"West Europe"` | no |
| [protection\_state](#input\_protection\_state) | Specifies the Protection state of the backup. Possible values are Invalid, IRPending, Protected, ProtectionStopped, ProtectionError and ProtectionPaused | `string` | `null` | no |
| [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group that is created to deploy the resources in. | `string` | n/a | yes |
| [retention\_daily\_config](#input\_retention\_daily\_config) | List of daily retention configuration. | ```list(object({ count = number }))``` | ```[ { "count": 7 } ]``` | no |
| [retention\_monthly\_config](#input\_retention\_monthly\_config) | The monthly retention configuration. | ```list(object({ count = number weekdays = list(string) weeks = list(string) }))``` | ```[ { "count": 7, "weekdays": [ "Sunday" ], "weeks": [ "Last" ] } ]``` | no |
| [retention\_weekly\_config](#input\_retention\_weekly\_config) | The weekly retention configuration. | ```list(object({ count = number weekdays = list(string) }))``` | ```[ { "count": 7, "weekdays": [ "Sunday" ] } ]``` | no |
| [retention\_yearly\_config](#input\_retention\_yearly\_config) | List of yearly retention configuration. | ```list(object({ count = number weekdays = list(string) weeks = list(string) months = list(string) }))``` | ```[ { "count": 7, "months": [ "January" ], "weekdays": [ "Sunday" ], "weeks": [ "Last" ] } ]``` | no |
| [storage\_accounts](#input\_storage\_accounts) | A map of Storage Accounts with name, associated resource groups and ID's that need to be backed up. | ```map(object({ storage_account_name = string storage_account_rg_name = string storage_account_id = string }))``` | `{}` | no |
| [storage\_share\_quota](#input\_storage\_share\_quota) | The maximum size of the share in gigabytes. | `number` | `null` | no |
| [tags](#input\_tags) | Tags used for the resources. | `map(string)` | n/a | yes |
| [timeouts\_config](#input\_timeouts\_config) | List of timeouts configuration. | ```list(object({ create = string update = string read = string delete = string }))``` | ```[ { "create": "60m", "delete": "120m", "read": "5m", "update": "60m" } ]``` | no |
| [vault\_name](#input\_vault\_name) | The name of the Recovery Services Vault. | `string` | n/a | yes |
| [virtual\_machines](#input\_virtual\_machines) | A map of Virtual Machines with the associated resource groups that need to be backed up. | ```map(object({ vm_name = string vm_rg_name = string include_datadisk = set(number) }))``` | `{}` | no |
| [vm\_backup\_policy\_name](#input\_vm\_backup\_policy\_name) | value | `string` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| [backup\_policy\_id](#output\_backup\_policy\_id) | The ID of the created Backup Policy |
| [protected\_vm\_id](#output\_protected\_vm\_id) | The ID of the protected Virtual Machine |
| [recovery\_services\_vault\_id](#output\_recovery\_services\_vault\_id) | The ID of the created Recovery Services Vault |

## Usage

### Minimal
```hcl
module "azure_backup" {
  source                = "provide the Azure DevOps module source"

  # Required input variables
  resource_group_name   = "provide RG name"
  location              = "West Europe"
  vault_name            = "provide vault name"
  vm_backup_policy_name = "provide backup policy name"

  tags = {
    environment = "dev"
    owner       = "name_owner"
    project     = "name_of_project"
  }

  # Optional: Configure retention settings and timeouts. If not provided these will use the defaults.
  backup_config = [
    {
      frequency = "Daily"
      time      = "23:00"
    }
  ]

  retention_daily_config = [
    {
      count = 7
    }
  ]

  retention_weekly_config = [
    {
      count    = 7
      weekdays = ["Sunday"]
    }
  ]

  retention_monthly_config = [
    {
      count    = 7
      weekdays = ["Sunday"]
      weeks    = ["Last"]
    }
  ]

  retention_yearly_config = [
    {
      count    = 7
      weekdays = ["Sunday"]
      weeks    = ["Last"]
      months   = ["January"]
    }
  ]

  timeouts_config = [
    {
      create = "60m"
      update = "60m"
      read   = "5m"
      delete = "120m"
    }
  ]

# Map of the Virtual Machines with the associated resource groups
  virtual_machines = {
    "vm1" = {
      vm_name          = "your_vm1_name"
      vm_rg_name       = "your_vm1_resource_group"
      include_datadisk = "true"
      exclude_datadisk = "false"
    },
    "vm2" = {
      vm_name          = "your_vm2_name"
      vm_rg_name       = "your_vm2_resource_group"
      include_datadisk = "true"
      exclude_datadisk = "false"
    }
    # add more blocks if needed
  }

  protection_state = "Protected"

# Input variables for the Storage Accounts with the associated resource groups and ID's to use for the Storage Account Container backup and File   # Share Backup
  storage_accounts = {
    "sa1" = {
      storage_account_name    = "your_sa1_name"
      storage_account_rg_name = "your_sa1_resource_group"
      storage_account_id      = "your_sa1_id"
    },
    "sa2" = {
      storage_account_name    = "your_sa2_name"
      storage_account_rg_name = "your_sa2_resource_group"
      storage_account_id      = "your_sa2_id"
    }
# Add more blocks if needed for the backup
  }

# Input variables for File Share configuration
  file_share_policy_name = "your_file_share_policy_name"
  storage_share_quota    = 100
}
