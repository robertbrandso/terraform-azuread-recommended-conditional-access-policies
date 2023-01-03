# ------
# BASICS
# ------
provider "azuread" {}

# -----------------------------------
# MODULE: CONDITIONAL ACCESS POLICIES
# -----------------------------------

module "default_conditional_access_policies" {
  source  = "robertbrandso/recommended-conditional-access-policies/azuread"
  version = "1.4.1"

  group_name_prefix          = "Access-Contoso"
  emergency_access_upn       = "emergency-access-caa@contoso.onmicrosoft.com"
  supported_device_platforms = ["android", "iOS", "linux", "macOS", "windows"]
  
  # Uncomment reporting_only_for_all_policies for testing purposes. If not, the policies will be applied.
  #reporting_only_for_all_policies = true
}