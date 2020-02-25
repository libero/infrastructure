variable "domain_name" {
  description = "Domain name, e.g. example.com"
}

variable "namespace" {
  description = "Kubernetes namespace, e.g. default"
}

variable "owner_id" {
  description = "Name that identifies this instance of ExternalDNS, e.g. my-identifier"
}

variable "role_name" {
  description = "Name of the role, e.g. Accounting-Role"
}
