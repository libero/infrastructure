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
    value = "{'time_local': $time_local, 'remote_addr': $remote_addr, 'request': $request, 'http_referrer': $http_referer, 'http_user_agent': $http_user_agent, 'status': $status, 'proxy_upstream_name': $proxy_upstream_name, 'upstream_status': $upstream_status', 'ingress_name': $ingress_name, 'namespace': $namespace}"
    type  = "string"
  }
}
