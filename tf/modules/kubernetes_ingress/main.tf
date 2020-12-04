resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "3.7.1"

  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}
