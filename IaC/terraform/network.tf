resource "azurerm_public_ip" "agic" {
  name                = "agic-pip"
  resource_group_name = azurerm_resource_group.agic.name
  location            = azurerm_resource_group.agic.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "kinsoftwares"
}

resource "azurerm_virtual_network" "agic" {
  name                = "agic-vnet"
  resource_group_name = azurerm_resource_group.agic.name
  location            = azurerm_resource_group.agic.location
  address_space       = ["192.168.0.0/24"]
}

resource "azurerm_subnet" "agic" {
  name                 = "agic-subnet"
  resource_group_name  = azurerm_resource_group.agic.name
  virtual_network_name = azurerm_virtual_network.agic.name
  address_prefixes     = ["192.168.0.0/24"]
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.agic.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.agic.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.agic.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.agic.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.agic.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.agic.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.agic.name}-rdrcfg"
}

resource "azurerm_application_gateway" "agic" {
  name                = "agic-appgateway"
  resource_group_name = azurerm_resource_group.agic.name
  location            = azurerm_resource_group.agic.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "agic-subnet"
    subnet_id = azurerm_subnet.agic.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agic.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}