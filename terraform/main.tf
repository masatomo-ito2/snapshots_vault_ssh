# Remote state for AWS VPC
data "terraform_remote_state" "aws_state" {
  backend = "remote"

  config = {
    organization = var.tfc_org
    workspaces = {
      name = var.tfc_aws_ws
    }
  }
}

# Remote state for Azure RG
data "terraform_remote_state" "azure_state" {
  backend = "remote"

  config = {
    organization = var.tfc_org
    workspaces = {
      name = var.tfc_azure_ws
    }
  }
}