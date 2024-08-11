output "recovery_services_vault_id" {
  description = "The ID of the created Recovery Services Vault"
  value       = azurerm_recovery_services_vault.vault.id
}

output "backup_policy_id" {
  description = "The ID of the created Backup Policy"
  value       = azurerm_backup_policy_vm.policy.id
}

output "protected_vm_id" {
  description = "The ID of the protected Virtual Machine"
  value       = values(azurerm_backup_protected_vm.protected_vms)[*].id
}
