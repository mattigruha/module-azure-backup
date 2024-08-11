resource "azurerm_backup_policy_file_share" "policy_fs" {
  count = var.create_file_share_policy != null ? 1 : 0

  name                = var.file_share_policy_name
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
}

resource "azurerm_backup_container_storage_account" "backup_container" {
  for_each            = var.storage_accounts
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  storage_account_id  = data.azurerm_storage_account.sa[each.key].id
}

resource "azurerm_storage_share" "storage_share" {

  for_each             = var.storage_accounts
  name                 = each.key
  storage_account_name = each.value.storage_account_name
  quota                = var.storage_share_quota

}

resource "azurerm_backup_protected_file_share" "backup_fs" {

  for_each = var.storage_accounts

  resource_group_name       = var.resource_group_name
  recovery_vault_name       = azurerm_recovery_services_vault.vault.name
  source_storage_account_id = data.azurerm_storage_account.sa[each.key].id
  source_file_share_name    = azurerm_storage_share.storage_share[each.key].name
  backup_policy_id          = azurerm_backup_policy_file_share.policy_fs[0].id
}
