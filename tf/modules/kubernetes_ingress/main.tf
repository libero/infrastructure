resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "3.7.1"

  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}

resource "helm_release" "ingress_nginx_nlb" {
  name = "ingress-nginx-nlb"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "3.7.1"

  values = [
    "${file("${path.module}/values-nlb.yaml")}"
  ]
}
