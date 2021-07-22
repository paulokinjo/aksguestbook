# Source code for the Resource Group Creation
resource "azurerm_resource_group" "guestbook" {
  name     = lower("rg-${var.resource_group_name}")
  location = var.region
}