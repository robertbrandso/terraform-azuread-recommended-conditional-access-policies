# ---------------------------
# CONDITIONAL ACCESS POLICIES
# ---------------------------

# Category: User

## CAU001
### Create exclude group
resource "azuread_group" "cau001_exclude" {
  count = var.cau001_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU001"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau001" {
  count = var.cau001_create == true ? 1 : 0

  display_name = "CAU001-All: Grant Require MFA for guests when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau001_state

  conditions {
    users {
      included_users  = ["GuestsOrExternalUsers"]
      excluded_groups = [azuread_group.cau001_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

## CAU002
### Create exclude group
resource "azuread_group" "cau002_exclude" {
  count = var.cau002_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU002"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau002" {
  count = var.cau002_create == true ? 1 : 0

  display_name = "CAU002-All: Grant Require MFA for All users when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau002_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cau002_exclude[0].object_id]
      excluded_users  = concat(var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : [], ["GuestsOrExternalUsers"])
      excluded_roles  = ["d29b2b05-8046-44ba-8758-1e26182fcf32"] # Directory Synchronization Accounts (https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference)
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

## CAU003
### Create exclude group
resource "azuread_group" "cau003_exclude" {
  count = var.cau003_create == true && var.cau003_included_application_ids != null ? 1 : 0 # Policy can't be created if no application ids in var.cau003_included_application_ids are defined, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU003"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau003" {
  count = var.cau003_create == true && var.cau003_included_application_ids != null ? 1 : 0 # Policy can't be created if no application ids in var.cau003_included_application_ids are defined.

  display_name = "CAU003-Selected: Block unapproved apps for guests when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau003_state

  conditions {
    users {
      included_users  = ["GuestsOrExternalUsers"]
      excluded_groups = [azuread_group.cau003_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = var.cau003_included_application_ids
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

## CAU004
### Create exclude group
resource "azuread_group" "cau004_exclude" {
  count = var.cau004_create == true && var.cau004_included_application_ids != null ? 1 : 0 # Policy can't be created if no application ids in var.cau004_included_application_ids are defined, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU004"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau004" {
  count = var.cau004_create == true && var.cau004_included_application_ids != null ? 1 : 0 # Policy can't be created if no application ids in var.cau004_included_application_ids are defined.

  display_name = "CAU004-Selected: Session route through MDCA for All users when Browser on Non-Compliant-v1.2"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau004_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cau004_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = var.cau004_included_application_ids
    }
    client_app_types = ["browser"]
    devices {
      filter {
        mode = "exclude"
        rule = "device.isCompliant -eq True -or device.trustType -eq \"ServerAD\"" # https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/concept-condition-filters-for-devices#supported-operators-and-device-properties-for-filters
      }
    }
  }

  grant_controls {
    built_in_controls = []
    operator          = "AND"
  }

  session_controls {
    cloud_app_security_policy = "blockDownloads"
  }

  lifecycle {
    ignore_changes = [
      grant_controls
    ]
  }
}

## CAU005
### Create exclude group
resource "azuread_group" "cau005_exclude" {
  count = var.cau005_create == true && var.cau005_included_application_ids != null ? 1 : 0 # Policy can't be created if no application ids in var.cau005_included_application_ids are defined, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU005"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau005" {
  count = var.cau005_create == true && var.cau005_included_application_ids != null ? 1 : 0 # Policy can't be created if no application ids in var.cau005_included_application_ids are defined.

  display_name = "CAU005-Selected: Session route through MDCA for All users when Browser on Compliant-v1.1"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau005_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cau005_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = var.cau005_included_application_ids
    }
    client_app_types = ["browser"]
    devices {
      filter {
        mode = "include"
        rule = "device.isCompliant -eq True -or device.trustType -eq \"ServerAD\"" # https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/concept-condition-filters-for-devices#supported-operators-and-device-properties-for-filters
      }
    }
  }

  grant_controls {
    built_in_controls = ["compliantDevice"]
    operator          = "OR"
  }

  session_controls {
    cloud_app_security_policy = "monitorOnly"
  }
}

## CAU006
### Create exclude group
resource "azuread_group" "cau006_exclude" {
  count = var.cau006_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU006"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau006" {
  count = var.cau006_create == true ? 1 : 0

  display_name = "CAU006-All: Grant Require MFA for High Risk Sign-in for All Users when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau006_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cau006_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types    = ["browser", "mobileAppsAndDesktopClients"]
    sign_in_risk_levels = ["high"]
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

## CAU007
### Create exclude group
resource "azuread_group" "cau007_exclude" {
  count = var.cau007_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU007"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau007" {
  count = var.cau007_create == true ? 1 : 0

  display_name = "CAU007-All: Grant Require MFA and Password reset for High Risk Users for All Users when All clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau007_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cau007_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["all"]
    user_risk_levels = ["high"]
  }

  grant_controls {
    built_in_controls = ["mfa", "passwordChange"]
    operator          = "AND"
  }
}

## CAU008
### Create exclude group
resource "azuread_group" "cau008_exclude" {
  count = var.cau008_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU008"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau008" {
  count = var.cau008_create == true ? 1 : 0

  display_name = "CAU008-All: Grant Require MFA for Admins when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau008_state

  conditions {
    users {
      included_roles  = var.privileged_role_ids
      excluded_groups = [azuread_group.cau008_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

## CAU009
### Create exclude group
resource "azuread_group" "cau009_exclude" {
  count = var.cau009_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU009"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau009" {
  count = var.cau009_create == true ? 1 : 0

  display_name = "CAU009-AzureManagement: Grant Require MFA for Azure Management for All Users when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau009_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cau009_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["797f4846-ba00-4fd7-ba43-dac1f8f63013"] # Microsoft Azure Management
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

## CAU010
### Create exclude group
resource "azuread_group" "cau010_exclude" {
  count = var.cau010_create == true && var.cau010_terms_of_use_ids != null ? 1 : 0 # Policy can't be created if no terms of use ids in var.cau010_terms_of_use_ids are defined, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU010"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau010" {
  count = var.cau010_create == true && var.cau010_terms_of_use_ids != null ? 1 : 0 # Policy can't be created if no terms of use ids in var.cau010_terms_of_use_ids are defined.

  display_name = "CAU010-All: Grant Require ToU for All Users when Browser and Modern Auth Clients-v1.1"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau010_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cau010_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
       excluded_applications = var.cau010_exclude_intune_enrollment == true ? [
         "0000000a-0000-0000-c000-000000000000", # Microsoft Intune
         "d4ebce55-015a-49b5-a083-c84d1797ae8c"  # Microsoft Intune Enrollment
         ] : null
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    built_in_controls = []
    operator          = "OR"
    terms_of_use      = var.cau010_terms_of_use_ids
  }
}

## CAU011 (optional)
### Create exclude group
resource "azuread_group" "cau011_exclude" {
  count = var.cau011_create == true && var.cau011_license_group_object_ids != null ? 1 : 0 # Policy can't be created if no object ids var.cau011_license_group_object_ids are defined, therefore no group needed either.

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAU011"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cau011" {
  count = var.cau011_create == true && var.cau011_license_group_object_ids != null ? 1 : 0 # Policy can't be created if no object ids var.cau011_license_group_object_ids are defined.

  display_name = "CAU011-All: Block access for All users except licensed when Browser and Modern Auth Clients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cau011_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = concat([azuread_group.cau011_exclude[0].object_id], var.cau011_license_group_object_ids)
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["browser", "mobileAppsAndDesktopClients"]
  }

  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

## CAU012
/* Policy will not be created. Same as CAL002. */