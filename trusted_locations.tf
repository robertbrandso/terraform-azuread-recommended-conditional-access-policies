# -----------------
# TRUSTED LOCATIONS
# -----------------

resource "azuread_named_location" "trusted_locations" {
  count = var.trusted_locations != null ? 1 : 0 # Don't add trusted locations if not specified.

  display_name = "Trusted locations"
  ip {
    ip_ranges = var.trusted_locations
    trusted   = true
  }
}