data "helm_repository" "cert-manager" {
  name = "cert-manager"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert_manager" {
  name = "cert-manager"
  chart = "cert-manager"
  repository = data.helm_repository.cert-manager.metadata[0].name
  version = "1.0.3"

  set {
    name  = "installCRDs"
    value = "true"
  }
}
