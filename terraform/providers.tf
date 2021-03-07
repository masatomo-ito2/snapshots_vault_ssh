provider "vault" {
}

provider "aws" {
  region = var.region
}

provider "azurerm" {
  features {}
}

