variable "application_name" {
  type        = string
  description = "The name of your application"
  default     = "asa-mz"
}

variable "region" {
  type = object({
    location = string
    location-short = string
    config_server_git_setting = object({
      uri          = string
      label        = optional(string)
      http_basic_auth = optional(object ({
        username = string
      }), {username = ""})
    })
  })
  description = "the region you want the Azure Spring Apps backend to be deployed to."
}

variable "apps" {
  type = list(object({
    app_name = string
    needs_identity = bool
    is_public = bool
    needs_custom_domain = bool
  }))
  description = "the apps you want to deploy in your spring apps instance"
}

variable "environment_variables" {
  type = map(string)
}

variable "git_repo_password" {
  type = string
  sensitive = true
  default = ""
}

variable "dns_name" {
  type = string
  default = "sampleapp.randomval-java-openlab.com"
}

variable "cert_name" {
  type = string
  default = "openlabcertificate"
  description = "name that will be used when storing your certificate in multiple services."
}

variable "shared_location" {
  type = string
  default = "westeurope"
  description = "location of the shared resources. Even though the shared resources, like Azure Front Door are Global, they still need to be placed in a resource group. This value will be used for the location of that resource group."
}

variable "use_self_signed_cert" {
  type = bool
  default = true
}

variable "cert_path" {
  type = string
  default = ""
}

variable "cert_password" {
  type = string
  sensitive = true
  default = ""
}