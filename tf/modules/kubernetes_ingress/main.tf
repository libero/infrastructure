resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "2.16.0"

  set {
    name  = "controller.replicaCount"
    value = 2
  }
}
