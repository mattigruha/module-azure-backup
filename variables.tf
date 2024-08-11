# ==================================
# Virtual Machine Backup variables #
# ==================================

# Input variables
variable "resource_group_name" {
  description = "Name of the resource group that is created to deploy the resources in."
  type        = string
}

variable "location" {
  description = "The location where the resource group is located."
  default     = "West Europe"
  type        = string
}

variable "tags" {
  description = "Tags used for the resources."
  type        = map(string)
}

variable "vault_name" {
  description = "The name of the Recovery Services Vault."
  type        = string
}

variable "vm_backup_policy_name" {
  description = "value"
  type        = string
  default     = false
}

##############################################################
# Input variables (optional) for the retention configuration #
##############################################################

variable "backup_config" {
  description = " Configures the Policy backup frequency and times"
  type = list(object({
    frequency = string
    time      = string
  }))
  default = [
    {
      frequency = "Daily"
      time      = "23:00"
    }
  ]
}

variable "retention_daily_config" {
  description = "List of daily retention configuration."
  type = list(object({
    count = number
  }))
  default = [
    {
      count = 7
    }
  ]
}

variable "retention_weekly_config" {
  description = "The weekly retention configuration."
  type = list(object({
    count    = number
    weekdays = list(string)
  }))
  default = [
    {
      count    = 7
      weekdays = ["Sunday"]
    }
  ]
}

variable "retention_monthly_config" {
  description = "The monthly retention configuration."
  type = list(object({
    count    = number
    weekdays = list(string)
    weeks    = list(string)
  }))
  default = [
    {
      count    = 7
      weekdays = ["Sunday"]
      weeks    = ["Last"]
    }
  ]
}

variable "retention_yearly_config" {
  description = "List of yearly retention configuration."
  type = list(object({
    count    = number
    weekdays = list(string)
    weeks    = list(string)
    months   = list(string)
  }))
  default = [
    {
      count    = 7
      weekdays = ["Sunday"]
      weeks    = ["Last"]
      months   = ["January"]
    }
  ]
}

variable "timeouts_config" {
  description = "List of timeouts configuration."
  type = list(object({
    create = string
    update = string
    read   = string
    delete = string
  }))
  default = [
    {
      create = "60m"
      update = "60m"
      read   = "5m"
      delete = "120m"
    }
  ]
}

#######################################################################
# For each loop to retrieve ID from one or multiple Virtual Machines #
#######################################################################

variable "virtual_machines" {
  description = "A map of Virtual Machines with the associated resource groups that need to be backed up."
  type = map(object({
    vm_name          = string
    vm_rg_name       = string
    include_datadisk = set(number)
  }))
  default = {}
}

variable "protection_state" {
  description = "Specifies the Protection state of the backup. Possible values are Invalid, IRPending, Protected, ProtectionStopped, ProtectionError and ProtectionPaused"
  type        = string
  default     = null
}

############################################################################
# For each loop to retrieve ID from one or multiple Azure Storage Accounts #
############################################################################

variable "storage_accounts" {
  description = "A map of Storage Accounts with name, associated resource groups and ID's that need to be backed up."
  type = map(object({
    storage_account_name    = string
    storage_account_rg_name = string
    storage_account_id      = string
  }))
  default = {}
}

############################################################################
# Variables for file share backup ##########################################
############################################################################

variable "create_file_share_policy" {
  description = "Set to true to create a file share policy."
  type        = bool
  default     = true
}

variable "file_share_policy_name" {
  description = "Name for the file share policy."
  type        = string
  default     = null
}

variable "storage_share_quota" {
  description = "The maximum size of the share in gigabytes."
  type        = number
  default     = null
}
