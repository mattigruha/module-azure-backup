resource "azurerm_backup_policy_vm" "policy" {
  name                = var.vm_backup_policy_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  dynamic "backup" {
    for_each = var.backup_config
    content {
      frequency = backup.value.frequency
      time      = backup.value.time
    }
  }

  dynamic "retention_daily" {
    for_each = var.retention_daily_config
    content {
      count = retention_daily.value.count
    }
  }

  dynamic "retention_weekly" {
    for_each = var.retention_weekly_config
    content {
      count    = retention_weekly.value.count
      weekdays = retention_weekly.value.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = var.retention_monthly_config
    content {
      count    = retention_monthly.value.count
      weekdays = retention_monthly.value.weekdays
      weeks    = retention_monthly.value.weeks
    }
  }

  dynamic "retention_yearly" {
    for_each = var.retention_yearly_config
    content {
      count    = retention_yearly.value.count
      weekdays = retention_yearly.value.weekdays
      weeks    = retention_yearly.value.weeks
      months   = retention_yearly.value.months
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts_config
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

data "azurerm_virtual_machine" "vm" {
  for_each = var.virtual_machines

  name                = each.value.vm_name
  resource_group_name = each.value.vm_rg_name
}

resource "azurerm_backup_protected_vm" "protected_vms" {
  for_each = var.virtual_machines

  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = data.azurerm_virtual_machine.vm[each.key].id
  backup_policy_id    = azurerm_backup_policy_vm.policy.id
  include_disk_luns   = each.value.include_datadisk
  protection_state    = var.protection_state
}
