variable "cluster_name" {
  description = "The EKS cluster name this VPC will support"
}

variable "domain_name" {
  description = "Domain name, e.g. example.com"
}

variable "namespace" {
  description = "Kubernetes namespace, e.g. default"
}

variable "role_name" {
  description = "Name of the role, e.g. Accounting-Role"
}
