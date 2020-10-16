data "helm_repository" "ingress-nginx" {
  name = "ingress-nginx"
  url  = "https://kubernetes.github.io/ingress-nginx"
}

resource "helm_release" "ingress_nginx" {
  name = "ingress-nginx"
  chart = "ingress-nginx"
  repository = data.helm_repository.ingress-nginx.metadata[0].name
  version = "2.16.0"
}
