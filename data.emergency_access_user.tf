# ---------------------
# EMERGENCY ACCESS USER
# ---------------------
data "azuread_user" "emergency_access_upn" {
  count = var.emergency_access_upn != null ? 1 : 0 # Don't get data about emergency access account if not specified.

  user_principal_name = var.emergency_access_upn
}