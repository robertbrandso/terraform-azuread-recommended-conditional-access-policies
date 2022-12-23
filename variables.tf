# ------
# COMMON
# ------

variable "group_name_prefix" {
  description = "(Required) Prefix for Azure AD group names to be used for exclude groups. Group name will be <prefix>-CA-Exclude-<policy sequence number>."
  type        = string
}

variable "emergency_access_upn" {
  description = "(Required) User principal name of your emergency access account which will be excluded from all policies."
  type        = string
}

variable "reporting_only_for_all_policies" {
  description = "(Optional) Overrides each policies state and sets it to report only mode."
  type        = bool
  default     = false
}

variable "trusted_locations" {
  description = "(Optional)  List of IP address ranges in IPv4 CIDR format (e.g. 1.2.3.4/32) or any allowable IPv6 format from IETF RFC596 to be marked as trusted location(s)."
  type        = list(string)
  default     = null
}

variable "supported_device_platforms" {
  description = "(Required) Specify a list of supported device platforms. Possible values are: 'android', 'iOS', 'linux', 'macOS', 'windows', 'windowsPhone'"
  type        = list(string)
}

variable "privileged_role_ids" {
  description = "(Optional) Defaults to a set of role IDs with high privileges. To define your own list of roles to include, specify the role IDs in this variable. Role IDs can be found in Microsoft docs: https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference."
  type        = list(string)
  default = [
    # Role IDs / template IDs can be found here: https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference

    ## Roles from the recommended policies list
    "fe930be7-5e62-47db-91af-98c3a49a38b1", # User Administrator
    "f28a1f50-f6e7-4571-818b-6a12f2af6b6c", # SharePoint Administrator
    "194ae4cb-b126-40b2-bd5b-6091b380977d", # Security Administrator
    "966707d0-3269-4727-9be2-8c3a10f19b9d", # Password Administrator
    "729827e3-9c14-49f7-bb1b-9608f156bbb8", # Helpdesk Administrator
    "62e90394-69f5-4237-9190-012177145e10", # Global Administrator
    "29232cdf-9323-42fd-ade2-1d097af3e4de", # Exchange Administrator
    "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9", # Conditional Access Administrator
    "b0f54661-2d74-4c50-afa3-1ec803f12efe", # Billing Administrator
    "c4e39bd9-1100-46d3-8c65-fb160da0071f", # Authentication Administrator

    ## Roles added extra to this module
    "0526716b-113d-4c15-b2c8-68e3c22b9f80", # Authentication Policy Administrator
    "e3973bdf-4987-49ae-837a-ba8e231c7286", # Azure DevOps Administrator
    "7495fdc4-34c4-4d15-a289-98788ce399fd", # Azure Information Protection Administrator
    "892c5842-a9a6-463a-8041-72aa08ca3cf6", # Cloud App Security Administrator
    "158c047a-c907-4556-b7ef-446551a6b5f7", # Cloud Application Administrator
    "7698a772-787b-4ac8-901f-60d6b08affd2", # Cloud Device Administrator
    "8329153b-31d0-4727-b945-745eb3bc5f31", # Domain Name Administrator
    "fdd7a751-b60b-444a-984c-02652fe8fa1c", # Groups Administrator
    "3a2c62db-5318-420d-8d74-23affee5d9d5", # Intune Administrator
    "2b745bdf-0803-4d80-aa65-822c4493daac", # Office Apps Administrator
    "7be44c8a-adaf-4e2a-84d6-ab2649e08a13", # Privileged Authentication Administrator
    "e8611ab8-c189-46e8-94e1-60213ab1f814", # Privileged Role Administrator
    "75941009-915a-4869-abe7-691bff18279e", # Skype for Business Administrator
    "69091246-20e8-4a56-aa4d-066075b2a7a8", # Teams Administrator
    "baf37b3a-610e-45da-9e62-d9d1e5e8914b", # Teams Communications Administrator
    "810a2642-a034-447f-a5e8-41beaa378541", # Yammer Administrator
    "32696413-001a-46ae-978c-ce0f6b3620d2", # Windows Update Deployment Administrator
  ]
}

# ---------------------------
# CONDITIONAL ACCESS POLICIES
# ---------------------------

# Category: Prerequisites

## CAP001
variable "cap001_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cap001_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAP002
variable "cap002_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cap002_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}


# Category: User

## CAU001
variable "cau001_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau001_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAU002
variable "cau002_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau002_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAU003
variable "cau003_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau003_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cau003_included_application_ids" {
  description = "(Optional) A list of application IDs the policy applies to."
  type        = list(string)
  default     = null
}

## CAU004
variable "cau004_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau004_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cau004_included_application_ids" {
  description = "(Optional) A list of application IDs the policy applies to."
  type        = list(string)
  default     = null
}

## CAU005
variable "cau005_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau005_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cau005_included_application_ids" {
  description = "(Optional) A list of application IDs the policy applies to."
  type        = list(string)
  default     = null
}

## CAU006
variable "cau006_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau006_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAU007
variable "cau007_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau007_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAU008
variable "cau008_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau008_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAU009
variable "cau009_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau009_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAU010
variable "cau010_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cau010_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cau010_terms_of_use_ids" {
  description = "(Optional) List of terms of use IDs required by the policy."
  type        = list(string)
  default     = null
}

## CAU011
variable "cau011_create" {
  description = "(Optional) Optional policy. Defaults to 'false'. Set to true if you want to create the policy."
  type        = bool
  default     = false
}

variable "cau011_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cau011_license_group_object_ids" {
  description = "(Optional) List of group object IDs which is used for licensing in Azure AD."
  type        = list(string)
  default     = null
}


# Category: Device

## CAD001
variable "cad001_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad001_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD002
variable "cad002_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad002_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD003
variable "cad003_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad003_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD004
variable "cad004_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad004_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD005
variable "cad005_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad005_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cad005_enable_for_browser" {
  description = "(Optional) Defaults to 'false'. Set to true if you also want to include 'browser' in client_app_types for CAD005."
  type        = bool
  default     = false
}

## CAD006
variable "cad006_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad006_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD007
variable "cad007_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad007_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cad007_sign_in_frequency_in_days" {
  description = "(Optional) Defaults to 7 days. Number of days to enforce sign-in frequency."
  type        = number
  default     = 7
}

## CAD008
variable "cad008_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad008_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cad008_sign_in_frequency_in_days" {
  description = "(Optional) Defaults to 1 day. Number of days to enforce sign-in frequency."
  type        = number
  default     = 1
}

## CAD009
variable "cad009_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad009_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD010
variable "cad010_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad010_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD011
variable "cad011_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad011_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD012
variable "cad012_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad012_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAD013
variable "cad013_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cad013_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cad013_included_application_ids" {
  description = "(Optional) A list of application IDs the policy applies to."
  type        = list(string)
  default     = null
}


# Category: Location

## CAL001
variable "cal001_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cal001_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cal001_blocked_location_ids" {
  description = "(Optional) List of blocked location IDs."
  type        = list(string)
  default     = null
}

## CAL002
variable "cal002_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cal002_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAL003
variable "cal003_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cal003_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cal003_included_user_upns" {
  description = "(Optional) List of UPNs to include in CAL003 to only accept logins from trusted locations."
  type        = list(string)
  default     = null
}

## CAL004
variable "cal004_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cal004_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

## CAL005
variable "cal005_create" {
  description = "(Optional) Defaults to 'true'. Set to false if you don't want to create the policy."
  type        = bool
  default     = true
}

variable "cal005_state" {
  description = "(Optional) Defaults to 'enabled'. Possible values are: 'enabled', 'disabled' and 'enabledForReportingButNotEnforced'."
  type        = string
  default     = "enabled"
}

variable "cal005_less_trusted_location_ids" {
  description = "(Optional) List of less-trusted location IDs."
  type        = list(string)
  default     = null
}