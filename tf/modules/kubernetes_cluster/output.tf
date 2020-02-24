output "worker_iam_role_name" {
  value = module.eks.worker_iam_role_name
  description = "Name of the role, e.g. Accounting-Role"
}
