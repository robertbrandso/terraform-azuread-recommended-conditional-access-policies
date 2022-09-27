# ------
# BASICS
# ------
terraform {
  required_version = ">= 1.1.5" # Not tested on Terraform version below 1.1.5, but will probably work.
  required_providers {
    azuread = {
      version = ">= 2.28" # Not tested on provider versions below 2.28, but will probably work.
    }
  }
}