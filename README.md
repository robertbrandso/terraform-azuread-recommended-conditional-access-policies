# Introduction
Based on the great work of [Kenneth van Surksum and his conditional access demystification whitepaper](https://www.vansurksum.com/2021/10/14/october-2021-update-of-the-conditional-access-demystified-whitepaper-and-workflow-cheat-sheet/), where he has created a spreadsheet with recommended default set of conditional access policies, this Terraform module creates the recommended policies - with some small changes and additions. This version is based on [version 1.3 of his recommended policies](https://github.com/kennethvs/blog/blob/master/Conditional%20Access%20Policy%20Description-v1.3.xlsx).

Thanks for your contribution to the community, Kenneth!

# API permissions needed
When running this as with a service principal the following API permissions are needed:
| **API permission**                   | **Description**                                                                |
| ------------------------------------ | ------------------------------------------------------------------------------ |
| `Policy.ReadWrite.ConditionalAccess` | Needed to read and create the conditional access policies.                     |
| `Policy.Read.All`                    | Needed to read and create the conditional access policies.                     |
| `Group.ReadWrite.All`                | Needed to create the Azure AD groups used for exclusion.                       |
| `User.Read.All`                      | Needed to get information about object ID of user accounts when providing UPN. |
| `Application.Read.All`               | Needed to include applications in ceartain policies.                           |

# Policies
The following policies can be created through this module:

| **Category** | **Sequence number** | **Name** | **Must explicity be enabled** | **Extra configuration needed** | **Optional configuration available** |
| ------------ | ------------------- | -------- | ----------------------------- | ------------------------------ | ------------------------------------ |
| Prerequisite | CAP001 | CAP001-All: Block Legacy Authentication for All users when OtherClients-v1.0 | No | No | No |
| Prerequisite | CAP002 | CAP002-O365: Grant Exchange ActiveSync Clients for All users when Approved App-v1.0 | No | No | No |
| User | CAU001 | CAU001-All: Grant Require MFA for guests when Browser and Modern Auth Clients-v1.0 | No | No | No |
| User | CAU002 | CAU002-All: Grant Require MFA for All users when Browser and Modern Auth Clients-v1.0 | No | No | No |
| User | CAU003 | CAU003-Selected: Block unapproved apps for guests when Browser and Modern Auth Clients-v1.0 | No | Define `cau003_included_application_ids` with application IDs to include. | No |
| User | CAU004 | CAU004-Selected: Session route through MCAS for All users when Browser on Non-Compliant-v1.1 | No | Define `cau004_included_application_ids` with application IDs to include. | No |
| User | CAU005 | CAU005-Selected: Session route through MCAS for All users when Browser on Compliant-v1.1 | No | Define `cau005_included_application_ids` with application IDs to include. | No |
| User | CAU006 | CAU006-All: Grant Require MFA for High Risk Sign-in for All Users when Browser and Modern Auth Clients-v1.0 | No | No | No |
| User | CAU007 | CAU007-All: Grant Require MFA and Password reset for High Risk Users for All Users when All clients-v1.0 | No | No | No |
| User | CAU008 | CAU008-All: Grant Require MFA for Admins when Browser and Modern Auth Clients-v1.0 | No | No | Define your own list of privileged roles in `privileged_role_ids`. See below for details about the default roles included. |
| User | CAU009 | CAU009-AzureManagement: Grant Require MFA for Azure Management for All Users when Browser and Modern Auth Clients-v1.0 | No | No | No |
| User | CAU010 | CAU010-All: Grant Require ToU for All Users when Browser and Modern Auth Clients | No | `cau010_terms_of_use_ids` | No |
| User | CAU011 | CAU011-All: Block access for All users except licensed when Browser and Modern Auth Clients-v1.0 | Yes, set `cau011_create` to `true` | Define `cau011_license_group_object_ids` with Azure AD group IDs to include. | No |
| Device | CAD001 | CAD001-O365: Grant macOS access for All users when Modern Auth Clients and Compliant-v1.0 | No | No | No |
| Device | CAD002 | CAD002-O365: Grant Windows access for All users when Modern Auth Clients and Compliant-v1.0 | No | No | No |
| Device | CAD003 | CAD003-O365: Grant iOS and Android access for All users when Modern Auth Clients and ApprovedApp or Compliant-v1.0 | No | No | No |
| Device | CAD004 | CAD004-O365: Grant Require MFA for All users when Browser and Non-Compliant-v1.1 | No | No | No |
| Device | CAD005 | CAD005-O365: Block access for unsupported device platforms for All users when Modern Auth Clients _(and Browser)_-v1.0 | No | Define `supported_device_platforms` with your supported device platforms. See below for details. | Set `cad005_enable_for_browser` to `true` to also enable the policy for browsers. |
| Device | CAD006 | CAD006-O365: Session Use app enforced restrictions on unmanaged device when All users when Browser-v1.1 | No | No | No |
| Device | CAD007 | CAD007-O365: Session set Sign-in Frequency for Apps for All users when Modern Auth Clients and Non-Compliant-v1.0 | No | No | Defaults to 7 days, but can be configured in `cad007_sign_in_frequency_in_days`. |
| Device | CAD008 | CAD008-All: Session set Sign-in Frequency for All users when Browser and Non-Compliant-v1.1 | No | No | Defaults to 1 day, but can be configured in `cad008_sign_in_frequency_in_days`. |
| Device | CAD009 | CAD009-All: Session disable browser persistence for All users when Browser and Non-Compliant-v1.1 | No | No | No |
| Device | CAD010 | CAD010-All: Require MFA for device join or registration when All clients-v1.0 | No | No | No |
| Location | CAL001 | CAL001-All: Block specified locations for All users when Browser and Modern Auth Clients-v1.0 | No | Define `cal001_blocked_location_ids` with location IDs to be blocked. See below under Tips and tricks for details. | No |
| Location | CAL002 | CAL002-All: Require MFA registration from trusted locations only for All users when Browser and Modern Auth Clients-v1.0 | No | Define CIDR in `trusted_locations`. See below for details. | No |
| Location | CAL003 | CAL003-All: Block all locations except trusted locations for Privileged users when Browser and Modern Auth Clients-v1.0 | No | Define CIDR in `trusted_locations`. See below for details. | Define your own list of privileged roles in `privileged_role_ids`. See below for details about the default roles included. |
| Location | CAL004 | CAL004-All: Block all locations except trusted locations for Selected users when Browser and Modern Auth Clients-v1.0 | No | Define CIDR in `trusted_locations`. See below for details. <br/> Define `cal004_included_user_upns` with user principal names of user that should be included. | No |


## Changes compared to Kenneth van Surksums recommended policies
The following changes are done compared to the recommended policies mentioned in the introduction:

| Policy | Description |
| ------ | ----------- |
| CAU002 | Excluded the `Directory Synchronization Accounts` role. |
| CAU006 | Fixed name of the policy, so it follows the naming standard. |
| CAU007 | Fixed name of the policy, so it follows the naming standard. |
| CAU007 | Changed `client_app_types` to `all`. `passwordChange` requires all client app types. |
| CAU008 | Azure AD roles have old names in Excel sheet. |
| CAU008 | Added more AAD roles to the list included_roles. |
| CAU010 | Added v1.0 at the end of the name. |
| CAU012 | Policy not created because authentication context is not supported in Terraform resource `azuread_conditional_access_policy` ([GitHub issue](https://github.com/hashicorp/terraform-provider-azuread/issues/882)) |
| CAU013 | Policy not created because authentication context is not supported in Terraform resource `azuread_conditional_access_policy` ([GitHub issue](https://github.com/hashicorp/terraform-provider-azuread/issues/882)) |
| CAD006 | Fixed name of the policy, so it follows the naming standard. |
| CAD010 | `client_app_types` needs to bet set to `all` when `included_user_actions = ["urn:user:registerdevice"]` is set. |
| CAD010 | Fixed name of the policy, so it follows the naming standard. |
| CAL003 | Extra policy added. Does not exist in Kenneths recommended policies. |
| CAL004 | Extra policy added. Does not exist in Kenneths recommended policies. |

# Common configuration

| **Configuration** | **Required/Optional** | **Details** |
| ----------------- | --------------------- | ----------- |
| `group_name_prefix` | Required | Prefix for Azure AD group names to be used for exclude groups. Group name will be `<prefix>-CA-Exclude-<policy sequence number>`. |
| `emergency_access_upn` | Required | User principal name of your emergency access account which will be excluded from all policies. |
| `supported_device_platforms` | Required | Specify a list of supported device platforms. Possible values are: `android`, `iOS`, `linux`, `macOS`, `windows`, `windowsPhone`. |
| `trusted_locations` | Optional | List of IP address ranges in IPv4 CIDR format (e.g. 1.2.3.4/32) or any allowable IPv6 format from IETF RFC596 to be marked as trusted location(s). |
| `reporting_only_for_all_policies` | Optional | Overrides each policies state and sets it to report only mode. |
| `privileged_role_ids` | Optional | To define your own list of roles to include, specify the role IDs in this variable. Role IDs can be found in the [Microsoft docs - Azure AD built-in roles](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference). Check out the list below to see the default roles. |

## Default privileged roles
The following privileged roles are set as default in the module:

* User Administrator
* SharePoint Administrator
* Security Administrator
* Password Administrator
* Helpdesk Administrator
* Global Administrator
* Exchange Administrator
* Conditional Access Administrator
* Billing Administrator
* Authentication Administrato   
* Authentication Policy Administrator
* Azure DevOps Administrator
* Azure Information Protection Administrator
* Cloud App Security Administrator
* Cloud Application Administrator
* Cloud Device Administrator
* Domain Name Administrator
* Groups Administrator
* Intune Administrator
* Office Apps Administrator
* Privileged Authentication Administrator
* Privileged Role Administrator
* Skype for Business Administrator
* Teams Administrator
* Teams Communications Administrator
* Yammer Administrator
* Windows Update Deployment Administrator

# Tips and tricks

## How to get the Terms of Use ID
In CAU010 you point to a Terms of Use ID in `cau010_terms_of_use_ids`. The first thing you have to do is to [create the terms of use](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/terms-of-use).

I haven't found an easy way to find the ID of the terms of use in the Azure Portal, but one way to find the ID is to query the Graph API at `GET /identityGovernance/termsOfUse/agreements`. Check the following links for details:
* [Microsoft Graph Docs: Terms of use - List agreements](https://docs.microsoft.com/en-us/graph/api/termsofusecontainer-list-agreements)
* [Graph Explorer: GET /identityGovernance/termsOfUse/agreements](https://developer.microsoft.com/en-us/graph/graph-explorer?request=identityGovernance%2FtermsOfUse%2Fagreements&method=GET&version=v1.0&GraphUrl=https://graph.microsoft.com)

## Blocked locations
Create blocked locations with the [`azuread_named_location`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/named_location) resource in your root module, and use the ID in `cal001_blocked_location_ids`.

## Organization specific conditional access policies
If you need your own organization specific conditional access policies, you can create them in your root module with the [`conditional_access_policy` resource](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/conditional_access_policy). In this way you can manage all your conditional access policies through Terraform.

# Example

Example with minimal configuration:

```hcl
# ------
# BASICS
# ------
provider "azuread" {}

# -----------------------------------
# MODULE: CONDITIONAL ACCESS POLICIES
# -----------------------------------

module "default_conditional_access_policies" {
  source  = "..."
  version = "..."

  group_name_prefix          = "Access-Contoso"
  emergency_access_upn       = "emergency-access-caa@contoso.onmicrosoft.com"
  supported_device_platforms = ["android", "iOS", "linux", "macOS", "windows"]
}
```

Example with more configuration:

```hcl
# ------
# BASICS
# ------
provider "azuread" {}

# ---------------
# NAMED LOCATIONS
# ---------------
resource "azuread_named_location" "norway" {
  display_name = "Norway"
  country {
    countries_and_regions = ["NO"]
  }
}

# -----------------------------------
# MODULE: CONDITIONAL ACCESS POLICIES
# -----------------------------------

module "default_conditional_access_policies" {
  source  = "..."
  version = "..."

  # Common configuration
  group_name_prefix               = "Access-Contoso"
  emergency_access_upn            = "emergency-access-caa@contoso.onmicrosoft.com"
  supported_device_platforms      = ["android", "iOS", "linux", "macOS", "windows"]
  reporting_only_for_all_policies = true

  # Custom settings for user policies
  cau004_included_application_ids = ["eafb53d0-2c31-45ca-91ed-0a262e9e64ec"] # Contoso ERP app
  cau005_included_application_ids = ["eafb53d0-2c31-45ca-91ed-0a262e9e64ec"] # Contoso ERP app
  cau010_terms_of_use_ids         = ["4c4d2ee8-bcbd-469f-b850-1843912a16eb"] # Contoso Terms of use
  
  # Custom settings for device policies
  cad005_enable_for_browser = true

  # Custom settings for location policies
  cal001_blocked_location_ids = [azuread_named_location.norway.id]
  cal004_included_user_upns   = [
    "serviceaccount-contoso-backup-m365@contoso.onmicrosoft.com",
    "serviceaccount-contoso-erp-app@contoso.onmicrosoft.com"
  ]
}
```