output "worker_iam_role_name" {
  value = module.eks.worker_iam_role_name
  description = "Name of the role, e.g. Accounting-Role"
}

output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
  description = "Security group ID attached to the EKS workers, e.g. sg-018caeb91524d23ff"
}

output "kubernetes_config" {
  value = {
    host = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token = data.aws_eks_cluster_auth.cluster.token
  }
  description = "Kubernetes provider configuration"
}
