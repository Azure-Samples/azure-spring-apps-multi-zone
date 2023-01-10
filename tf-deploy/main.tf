# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.25.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

locals {
  application_name = "${var.application_name}-${lower(random_string.rand-name.result)}"
}

resource "random_string" "rand-name" {
  length  = 5
  upper   = false
  numeric  = false
  lower   = true
  special = false
}

module "region" {
  source = "./modules/region"
  application_name = local.application_name
  location = var.region.location
  location-short = var.region.location-short

  dns_name = var.dns_name
  cert_name = var.cert_name
  use_self_signed_cert = var.use_self_signed_cert
  cert_path = var.cert_path
  cert_password = var.cert_password

  config_server_git_setting = var.region.config_server_git_setting
  git_repo_password = var.git_repo_password
  apps = var.apps
  environment_variables = var.environment_variables
}