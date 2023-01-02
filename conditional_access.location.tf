# ---------------------------
# CONDITIONAL ACCESS POLICIES
# ---------------------------

# Category: Location

## CAL001
### Create exclude group
resource "azuread_group" "cal001_exclude" {
  count = var.cal001_create == true && var.cal001_blocked_location_ids != null ? 1 : 0 # Policy can't be created if no location ids in var.cal001_blocked_location_ids are defined, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAL001"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cal001" {
  count = var.cal001_create == true && var.cal001_blocked_location_ids != null ? 1 : 0 # Policy can't be created if no location ids in var.cal001_blocked_location_ids are defined.

  display_name = "CAL001-All: Block specified locations for All users when Browser and Modern Auth Clients-v1.1"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cal001_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cal001_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
    locations {
      included_locations = var.cal001_blocked_location_ids
    }
  }

  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

## CAL002
### Create exclude group
resource "azuread_group" "cal002_exclude" {
  count = var.cal002_create == true && var.trusted_locations != null ? 1 : 0 # Policy can't be created if no trusted location are defined in var.trusted_locations, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAL002"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cal002" {
  count = var.cal002_create == true && var.trusted_locations != null ? 1 : 0 # Policy can't be created if no trusted location are defined in var.trusted_locations.

  display_name = "CAL002-All: Require MFA registration from trusted locations only for All users when Browser and Modern Auth Clients-v1.2"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cal002_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cal002_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_user_actions = ["urn:user:registersecurityinfo"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
    locations {
      included_locations = ["All"]
      excluded_locations = ["AllTrusted"]
    }
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

## CAL003
### Get data about the UPNs defined
data "azuread_users" "cal003_include" {
  count = var.cal003_included_user_upns != null ? 1 : 0 # Don't get data about users if var.cal003_included_user_upns if not specified.

  user_principal_names = var.cal003_included_user_upns
}

### Create exclude group
resource "azuread_group" "cal003_exclude" {
  count = var.cal003_create == true && var.cal003_included_user_upns != null && var.trusted_locations != null ? 1 : 0 # Policy can't be created if no UPNs are defined in var.cal003_included_user_upns or no trusted locations are defined in var.trusted_locations, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAL003"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cal003" {
  count = var.cal003_create == true && var.cal003_included_user_upns != null && var.trusted_locations != null ? 1 : 0 # Policy can't be created if no UPNs are defined in var.cal003_included_user_upns or no trusted locations are defined in var.trusted_locations.

  display_name = "CAL003:All: Block Access for Specified Service Accounts except from Provided Trusted Locations when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cal003_state

  conditions {
    users {
      included_users  = data.azuread_users.cal003_include[0].object_ids
      excluded_groups = [azuread_group.cal003_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
    locations {
      included_locations = ["All"]
      excluded_locations = ["AllTrusted"]
    }
  }

  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

## CAL004
### Create exclude group
resource "azuread_group" "cal004_exclude" {
  count = var.cal004_create == true && var.trusted_locations != null ? 1 : 0 # Policy can't be created if no trusted location are defined in var.trusted_locations, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAL004"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cal004" {
  count = var.cal004_create == true && var.trusted_locations != null ? 1 : 0 # Policy can't be created if no trusted location are defined in var.trusted_locations.

  display_name = "CAL004-All: Block access for Admins from non-trusted locations when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cal004_state

  conditions {
    users {
      included_roles  = var.privileged_role_ids
      excluded_groups = [azuread_group.cal004_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
    locations {
      included_locations = ["All"]
      excluded_locations = ["AllTrusted"]
    }
  }

  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

## CAL005
### Create exclude group
resource "azuread_group" "cal005_exclude" {
  count = var.cal005_create == true && var.cal005_less_trusted_location_ids != null ? 1 : 0 # Policy can't be created if no less-trusted location are defined in var.cal005_less_trusted_location_ids, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAL005"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cal005" {
  count = var.cal005_create == true && var.cal005_less_trusted_location_ids != null ? 1 : 0 # Policy can't be created if no trusted location are defined in var.cal005_less_trusted_location_ids.

  display_name = "CAL005-Selected: Grant access for All users on less-trusted locations when Browser and Modern Auth Clients and Compliant-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cal005_state

  conditions {
    users {
      included_roles  = var.privileged_role_ids
      excluded_groups = [azuread_group.cal005_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
      excluded_applications = ["Office365"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
    locations {
      included_locations = var.cal005_less_trusted_location_ids
    }
  }

  grant_controls {
    built_in_controls = [
      "compliantDevice",
      "domainJoinedDevice",
      "approvedApplication"
      ]
    operator          = "OR"
  }
}