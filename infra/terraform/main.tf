terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">= 3.85" }
  }
}

provider "azurerm" {
  features {}
}

variable "location"    { default = "southeastasia" }
variable "environment" { default = "dev" }
variable "project_name" { default = "eshop" }

locals {
  prefix = "${var.project_name}-${var.environment}"
  tags   = { Environment = var.environment, Project = var.project_name }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.prefix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_container_registry" "main" {
  name                = replace("acr${var.project_name}${var.environment}", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"
  admin_enabled       = false
}

output "acr_login_server" { value = azurerm_container_registry.main.login_server }
