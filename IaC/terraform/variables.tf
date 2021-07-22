variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "region" {
  type        = string
  description = "Region where the resource must be created"
}

variable "aks_name" {
  type        = string
  description = "Azure Kubernetes Cluster Name"
}

variable "app_name" {
  type        = string
  description = "The name of the app"
}

variable "admin_username" {
  type        = string
  description = "Cluster admin username"
}

variable "client_id" {
  type        = string
  description = "Service Principal client id"
}

variable "client_secret" {
  type        = string
  description = "Service Principal client secret"
}