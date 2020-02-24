variable "cluster_name" {
  description = "The EKS cluster name this VPC will support"
}

variable "hosted_zone_id" {
  description = "ID of the hosted zone, e.g. Z111111QQQQQQQ"
}

variable "namespace" {
  description = "Kubernetes namespace, e.g. default"
}

variable "role_name" {
  description = "Name of the role, e.g. Accounting-Role"
}
