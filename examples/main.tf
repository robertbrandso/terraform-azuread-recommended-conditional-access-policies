# ------
# BASICS
# ------
provider "azuread" {}

# -----------------------------------
# MODULE: CONDITIONAL ACCESS POLICIES
# -----------------------------------

module "default_conditional_access_policies" {
  source  = "../"

  reporting_only_for_all_policies = true
  
  group_name_prefix          = "Access-Contoso"
  emergency_access_upn       = "t0robertb@brandso.no"
  supported_device_platforms = ["android", "iOS", "linux", "macOS", "windows"]
  cal005_less_trusted_location_ids = [ azuread_named_location.russia.id ]
  trusted_locations = [ "0.0.0.0/0" ]
  cal001_blocked_location_ids = [ azuread_named_location.russia.id ]
  cad005_enable_for_browser = true
  #cal003_included_user_upns = [ "test@brandso.no" ]
  cau003_included_application_ids = [ "4d168fc4-22d6-491e-88e7-7bb4cccef079" ]
  cau004_included_application_ids = [ "4d168fc4-22d6-491e-88e7-7bb4cccef079" ]
  cau005_included_application_ids = [ "4d168fc4-22d6-491e-88e7-7bb4cccef079" ]
  cau010_terms_of_use_ids = [ "290e86b4-e715-48c8-9554-39af84187e74" ]
  cau010_exclude_intune_enrollment = true
  
}

resource "azuread_named_location" "russia" {
  display_name = "Russia"
  country {
    countries_and_regions = ["RU"]
  }
}