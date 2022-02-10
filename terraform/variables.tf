### Common ###

variable "template_path" {
  type = string
}

variable "tfc_org" {
  type = string
}

variable "env" {
  type = string
}

variable "vault_addr" {
  type = string
}

variable "vault_namespace" {
  type = string
}

###  For AWS ###

# Required
variable "tfc_aws_ws" {
  type = string
}

variable "region" {
  type = string
}

# Optional
variable "ssh_key_name" {
  type = string
}

###  For Azure ###

# Required
variable "tfc_azure_ws" {
  type = string
}

