# Changelog

## v1.4.0 - 2023-01-02
* CAU002: Changed name to ...v1.0 (from v1.1) to allign with Kenneths Excel sheet. No other changes.
* CAU004: Added  -or device.trustType -eq \"ServerAD\". Bumped version.
* CAU005: Added  -or device.trustType -eq \"ServerAD\". Bumped version.
* CAU010: Added option to exclude Intune enrollment through `cau010_exclude_intune_enrollment`. Defaults to false. Details in README.md. Bumped version.
* CAD001: Changed name to ...v1.1 (from v1.0) to allign with Kenneths Excel sheet. No other changes.
* CAD002: Added domainJoinedDevice to grant control. Bumped version.
* CAD003: Changed name to ...v1.1 (from v1.0) to allign with Kenneths Excel sheet. No other changes.
* CAD004: Added  -or device.trustType -eq \"ServerAD\". Bumped version.
* CAD005: Changed name to ...v1.1 (from v1.0) to allign with Kenneths Excel sheet. No other changes.
* CAD006: Added  -or device.trustType -eq \"ServerAD\". Added mobileAppsAndDesktopClients. Bumped version and changed name.
* CAD007: Added  -or device.trustType -eq \"ServerAD\". Bumped version.
* CAD009: Added  -or device.trustType -eq \"ServerAD\". Bumped version.
* The note about CAU012 and CAU013 in version 1.3 removed. These two policies is removed in version 1.4 in Kenneths Excel sheet. These policies were never created by this module.
* A new note in README.md about policy CAU012 in Kenneths Excel sheet. Policy is the same as CAL002.
* CAD011: Added new policy.
* CAD012: Added new policy.
* CAD013: Added new policy.
* CAL001: Changed name to ...v1.1 (from v1.0) to allign with Kenneths Excel sheet. No other changes.
* CAL002: Changed from block to require MFA. Bumped version.
* CAL003/CAL004: Switched CAL003 and CAL004 so they match Kenneths Excel sheet and renamed them. Former CAL003 is now CAL004 and vice versa. No changes to the functionality of the policies. These two policies was originally introduced by this module and didn't exist in Kenneths version 1.3.
* CAL005: Added new policy.

## v1.3.0 - 2022-12-21
* No actual changes. Bumping module to v1.3.0 just to align with Kenneth van Surksum versioning.

## v1.0.0 - 2022-09-27
* Initial version