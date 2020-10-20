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

resource "kubernetes_manifest" "cert_manager" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt"
    }
    "spec" = {
      "acme" = {
        "email" = "team@hive.review"
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" = {
          "name" = "letsencrypt"
        }
        "solvers" = {
          "http01" = {
            "ingress" = {
              "class" = "nginx"
            }
          }
        }
      }
    }
  }
}
