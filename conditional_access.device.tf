# ---------------------------
# CONDITIONAL ACCESS POLICIES
# ---------------------------

# Category: Device

## CAD001
### Create exclude group
resource "azuread_group" "cad001_exclude" {
  count = var.cad001_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD001"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad001" {
  count = var.cad001_create == true ? 1 : 0

  display_name = "CAD001-O365: Grant macOS access for All users when Modern Auth Clients and Compliant-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad001_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad001_exclude[0].object_id]
      excluded_users  = concat(var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : [], ["GuestsOrExternalUsers"])
    }
    applications {
      included_applications = ["Office365"]
    }
    client_app_types = ["mobileAppsAndDesktopClients"]
    platforms {
      included_platforms = ["macOS"]
    }
  }

  grant_controls {
    built_in_controls = ["compliantDevice"]
    operator          = "OR"
  }
}

## CAD002
### Create exclude group
resource "azuread_group" "cad002_exclude" {
  count = var.cad002_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD002"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad002" {
  count = var.cad002_create == true ? 1 : 0

  display_name = "CAD002-O365: Grant Windows access for All users when Modern Auth Clients and Compliant-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad002_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad002_exclude[0].object_id]
      excluded_users  = concat(var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : [], ["GuestsOrExternalUsers"])
    }
    applications {
      included_applications = ["Office365"]
    }
    client_app_types = ["mobileAppsAndDesktopClients"]
    platforms {
      included_platforms = ["windows"]
    }
  }

  grant_controls {
    built_in_controls = ["compliantDevice"]
    operator          = "OR"
  }
}

## CAD003
### Create exclude group
resource "azuread_group" "cad003_exclude" {
  count = var.cad003_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD003"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad003" {
  count = var.cad003_create == true ? 1 : 0

  display_name = "CAD003-O365: Grant iOS and Android access for All users when Modern Auth Clients and ApprovedApp or Compliant-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad003_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad003_exclude[0].object_id]
      excluded_users  = concat(var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : [], ["GuestsOrExternalUsers"])
    }
    applications {
      included_applications = ["Office365"]
    }
    client_app_types = ["mobileAppsAndDesktopClients"]
    platforms {
      included_platforms = ["iOS", "android"]
    }
  }

  grant_controls {
    built_in_controls = ["compliantDevice", "approvedApplication"]
    operator          = "OR"
  }
}

## CAD004
### Create exclude group
resource "azuread_group" "cad004_exclude" {
  count = var.cad004_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD004"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad004" {
  count = var.cad004_create == true ? 1 : 0

  display_name = "CAD004-O365: Grant Require MFA for All users when Browser and Non-Compliant-v1.1"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad004_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad004_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["Office365"]
    }
    client_app_types = ["browser"]
    devices {
      filter {
        mode = "exclude"
        rule = "device.isCompliant -eq True" # https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/concept-condition-filters-for-devices#supported-operators-and-device-properties-for-filters
      }
    }
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

## CAD005
### Create exclude group
resource "azuread_group" "cad005_exclude" {
  count = var.cad005_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD005"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad005" {
  count = var.cad005_create == true ? 1 : 0

  display_name = var.cad005_enable_for_browser == true ? "CAD005-O365: Block access for unsupported device platforms for All users when Modern Auth Clients and Browser-v1.0" : "CAD005-O365: Block access for unsupported device platforms for All users when Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad005_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad005_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["Office365"]
    }
    # Optionally also include browser in policy by setting var.cad005_enable_for_browser to 'true'.
    client_app_types = concat(["mobileAppsAndDesktopClients"], var.cad005_enable_for_browser == true ? ["browser"] : [])
    platforms {
      included_platforms = ["all"]
      excluded_platforms = var.supported_device_platforms
    }
  }

  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

## CAD006
### Create exclude group
resource "azuread_group" "cad006_exclude" {
  count = var.cad006_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD006"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad006" {
  count = var.cad006_create == true ? 1 : 0

  display_name = "CAD006-O365: Session Use app enforced restrictions on unmanaged device when All users when Browser-v1.1"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad006_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad006_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["Office365"]
    }
    client_app_types = ["browser"]
    devices {
      filter {
        mode = "exclude"
        rule = "device.isCompliant -eq True" # https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/concept-condition-filters-for-devices#supported-operators-and-device-properties-for-filters
      }
    }
  }

  grant_controls {
    built_in_controls = []
    operator          = "AND"
  }

  session_controls {
    application_enforced_restrictions_enabled = true
  }

  lifecycle {
    ignore_changes = [
      grant_controls
    ]
  }
}

## CAD007
### Create exclude group
resource "azuread_group" "cad007_exclude" {
  count = var.cad007_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD007"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad007" {
  count = var.cad007_create == true ? 1 : 0

  display_name = "CAD007-O365: Session set Sign-in Frequency for Apps for All users when Modern Auth Clients and Non-Compliant-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad007_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad007_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["Office365"]
    }
    client_app_types = ["mobileAppsAndDesktopClients"]
    platforms {
      included_platforms = ["iOS", "android"]
    }
    devices {
      filter {
        mode = "exclude"
        rule = "device.isCompliant -eq True" # https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/concept-condition-filters-for-devices#supported-operators-and-device-properties-for-filters
      }
    }
  }

  grant_controls {
    built_in_controls = []
    operator          = "AND"
  }

  session_controls {
    sign_in_frequency        = var.cad007_sign_in_frequency_in_days
    sign_in_frequency_period = "days"
  }

  lifecycle {
    ignore_changes = [
      grant_controls
    ]
  }
}

## CAD008
### Create exclude group
resource "azuread_group" "cad008_exclude" {
  count = var.cad008_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD008"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad008" {
  count = var.cad008_create == true ? 1 : 0

  display_name = "CAD008-All: Session set Sign-in Frequency for All users when Browser and Non-Compliant-v1.1"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad008_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad008_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser"]
    devices {
      filter {
        mode = "exclude"
        rule = "device.isCompliant -eq True" # https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/concept-condition-filters-for-devices#supported-operators-and-device-properties-for-filters
      }
    }
  }

  grant_controls {
    built_in_controls = []
    operator          = "AND"
  }

  session_controls {
    sign_in_frequency        = var.cad008_sign_in_frequency_in_days
    sign_in_frequency_period = "days"
  }

  lifecycle {
    ignore_changes = [
      grant_controls
    ]
  }
}

## CAD009
### Create exclude group
resource "azuread_group" "cad009_exclude" {
  count = var.cad009_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD009"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad009" {
  count = var.cad009_create == true ? 1 : 0

  display_name = "CAD009-All: Session disable browser persistence for All users when Browser and Non-Compliant-v1.1"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad009_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad009_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser"]
    devices {
      filter {
        mode = "exclude"
        rule = "device.isCompliant -eq True" # https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/concept-condition-filters-for-devices#supported-operators-and-device-properties-for-filters
      }
    }
  }

  grant_controls {
    built_in_controls = []
    operator          = "AND"
  }

  session_controls {
    persistent_browser_mode = "never"
  }

  lifecycle {
    ignore_changes = [
      grant_controls
    ]
  }
}

## CAD010
### Create exclude group
resource "azuread_group" "cad010_exclude" {
  count = var.cad010_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAD010"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cad010" {
  count = var.cad010_create == true ? 1 : 0

  display_name = "CAD010-All: Require MFA for device join or registration when All clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cad010_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cad010_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_user_actions = ["urn:user:registerdevice"]
    }
    client_app_types = ["all"]
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}