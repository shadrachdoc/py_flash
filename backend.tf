terraform {
  backend "azurerm" {
    resource_group_name   = "test"
    storage_account_name  = "statefile224"
    container_name        = "statefiles"
    key                   = "terraform.tfstate"
  }
}

