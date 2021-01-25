terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  subscription_id = "d0767e87-e2a6-4477-a762-768ce1367057"
  features {
    
  }
}

# Backend configuration
terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate"
    storage_account_name  = "tfstate4445"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}