### Common ###

variable "tfc_org" {
  type = string
}

variable "env" {
  type    = string
  default = "demo"
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

