# Retrieve data from one or multiple storage accounts for the File Share backup solution
data "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                = each.value.storage_account_name
  resource_group_name = each.value.storage_account_rg_name
}
