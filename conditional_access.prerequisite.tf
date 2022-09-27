# ---------------------------
# CONDITIONAL ACCESS POLICIES
# ---------------------------

# Category: Prerequisite

## CAP001
### Create exclude group
resource "azuread_group" "cap001_exclude" {
  count = var.cap001_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAP001"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cap001" {
  count = var.cap001_create == true ? 1 : 0

  display_name = "CAP001-All: Block Legacy Authentication for All users when OtherClients-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cap001_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap001_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["other"]
  }

  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}


## CAP002
### Create exclude group
resource "azuread_group" "cap002_exclude" {
  count = var.cap002_create == true ? 1 : 0

  display_name            = "${var.group_name_prefix}-CA-Exclude-CAP002"
  security_enabled        = true
  prevent_duplicate_names = true
}

### Create policy
resource "azuread_conditional_access_policy" "cap002" {
  count = var.cap002_create == true ? 1 : 0

  display_name = "CAP002-O365: Grant Exchange ActiveSync Clients for All users when Approved App-v1.0"
  state        = var.reporting_only_for_all_policies == true ? "enabledForReportingButNotEnforced" : var.cap002_state

  conditions {
    users {
      included_users  = ["All"]
      excluded_groups = [azuread_group.cap002_exclude[0].object_id]
      excluded_users  = var.emergency_access_upn != null ? [data.azuread_user.emergency_access_upn[0].object_id] : null
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["exchangeActiveSync"]
  }

  grant_controls {
    built_in_controls = ["approvedApplication"]
    operator          = "OR"
  }
}