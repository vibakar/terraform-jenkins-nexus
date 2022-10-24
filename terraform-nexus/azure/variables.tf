variable "global_id" {
  type        = string
  description = "Global ID for resource names"
  default = "nexus-test"
}

variable "location" {
  type        = string
  description = "Location of deployed resource"
  default = "uksouth"
}

variable "public_domain_name" {
  type        = string
  description = "Name of the public domain"
  default = "nexus-test"
}

variable "ssh_pub_key" {
  type        = string
  description = "(optional) describe your variable"
}

variable "ssh_private_key" {
  type        = string
  description = "(optional) describe your variable"
}

variable "client_secret" {
  type        = string
  description = "Password for service principal"
  sensitive   = false
}

variable "client_id" {
  type        = string
  description = "ID of the service principal"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID for service principal"
}

variable "subscription_id" {
  type        = string
  description = "ID of Azure subscription"
}

variable "admin_username" {
  type        = string
  description = "Username of the admin on the VM"
  default = "vmadmin"
}