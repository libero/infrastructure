resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "3.7.1"

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set_string {
    name  = "controller.config.use-gzip"
    value = "true"
  }

  set {
    name  = "controller.config.enable-brotli"
    value = "true"
    type  = "string"
  }
}
