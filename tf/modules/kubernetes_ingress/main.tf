resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "3.7.1"

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    name  = "controller.config.use-gzip"
    value = "true"
    type  = "string"
  }

  set {
    name  = "controller.config.enable-brotli"
    value = "true"
    type  = "string"
  }

  set {
    name  = "controller.config.log-format-escape-json"
    value = "true"
    type  = "string"
  }

  set {
    name  = "controller.config.log-format-upstream"
    value = "${jsonencode(jsondecode(file("${path.module}/nginx-log-format-upstream.json")))}"
    type  = "string"
  }
}
