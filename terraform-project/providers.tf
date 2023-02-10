terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.42.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
}

provider "aws" {
  # Configuration options
}