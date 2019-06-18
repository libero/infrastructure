provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "local_file" "https_registration_key" {
    filename = "registration.key"
}

resource "acme_registration" "reg" {
  account_key_pem = "${data.local_file.https_registration_key.content}"
  email_address   = "libero-admin@elifesciences.org"
}

data "local_file" "https_certificate_key" {
    filename = "certificate.key"
}

resource "tls_cert_request" "req" {
  key_algorithm   = "RSA"
  # Only an irreversable secure hash of the private key will be stored in the Terraform state. https://www.terraform.io/docs/providers/tls/r/cert_request.html
  private_key_pem = "${data.local_file.https_certificate_key.content}"
  # can't make wildcard certificates work easily
  dns_names       = ["${var.env}--dummy-api.libero.pub", "${var.env}--pattern-library.libero.pub", "${var.env}--api-gateway.libero.pub", "${var.env}--jats-ingester.libero.pub"]
  subject {
    common_name = "${var.env}.libero.pub"
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  certificate_request_pem   = "${tls_cert_request.req.cert_request_pem}"
  min_days_remaining         = 30

  dns_challenge {
    provider = "route53"
  }
}

output "https_certificate_pem" {
  value = "${acme_certificate.certificate.certificate_pem}"
}

output "https_issuer_pem" {
  value = "${acme_certificate.certificate.issuer_pem}"
}
