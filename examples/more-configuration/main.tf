# ------
# BASICS
# ------
provider "azuread" {}

# ---------------
# NAMED LOCATIONS
# ---------------
resource "azuread_named_location" "north_korea" {
  display_name = "North Korea"
  country {
    countries_and_regions = ["KP"]
  }
}

# -----------------------------------
# MODULE: CONDITIONAL ACCESS POLICIES
# -----------------------------------

module "default_conditional_access_policies" {
  source  = "robertbrandso/recommended-conditional-access-policies/azuread"
  version = "1.4.1"

  # Common configuration
  group_name_prefix               = "Access-Contoso"
  emergency_access_upn            = "emergency-access-caa@contoso.onmicrosoft.com"
  supported_device_platforms      = ["android", "iOS", "linux", "macOS", "windows"]
  reporting_only_for_all_policies = true
  trusted_locations = [
    "1.2.3.4/32", # Oslo office
    "4.3.2.1/32"  # Stockholm office
  ]

  # Custom settings for user policies
  cau004_included_application_ids  = ["eafb53d0-2c31-45ca-91ed-0a262e9e64ec"] # Contoso ERP app
  cau005_included_application_ids  = ["eafb53d0-2c31-45ca-91ed-0a262e9e64ec"] # Contoso ERP app
  cau010_terms_of_use_ids          = ["4c4d2ee8-bcbd-469f-b850-1843912a16eb"] # Contoso Terms of use
  cau010_exclude_intune_enrollment = true
  
  # Custom settings for device policies
  cad005_enable_for_browser = true

  # Custom settings for location policies
  cal001_blocked_location_ids = [azuread_named_location.north_korea.id]
  cal003_included_user_upns   = [
    "serviceaccount-contoso-backup-m365@contoso.onmicrosoft.com",
    "serviceaccount-contoso-erp-app@contoso.onmicrosoft.com"
  ]
}