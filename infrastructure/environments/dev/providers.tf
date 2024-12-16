terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.13.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "afae5ba1-00f0-4d25-830d-69cdace3c01f"
}
