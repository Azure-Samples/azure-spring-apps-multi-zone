# main.tf

## Register providers

The main.tf file registers the necessary Terraform providers for working with the Azure platform.

```terraform
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
```

## locals

The file also contains 1 local variable.

```terraform
locals {
  application_name = "${var.application_name}-${lower(random_string.rand-name.result)}"
}
```

The `application_name` is a concatenation of your application_name and a random string value.

## Region module

Even though this template will only deploy to 1 region, there is a region module being used during deployment. Take a look at [Azure Spring Apps multi region reference architecture](https://github.com/Azure-Samples/azure-spring-apps-multi-region) for an overview of deploying to multiple regions. You will see the template and modules are very similar.

For the region you configured in your [tfvars](../tf-deploy/myvars.tfvars) file, the `region` module will be executed. You can find more info on this module in the [region.md](region.md) file.

```terraform
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
```
