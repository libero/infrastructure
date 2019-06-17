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
    filename = "registration.key"
}

resource "tls_cert_request" "req" {
  key_algorithm   = "RSA"
  private_key_pem = "${data.local_file.https_certificate_key.content}"
  #dns_names       = ["www.example.com", "www2.example.com"]

  subject {
    common_name = "unstable.libero.pub"
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  certificate_request_pem   = "${tls_cert_request.req.cert_request_pem}"
  #common_name               = "unstable.libero.pub"
  #subject_alternative_names = ["www2.example.com"]
  min_days_remaining         = 30

  dns_challenge {
    provider = "route53"
  }
}

output "https_certificate_pem" {
  value = "${acme_certificate.certificate.certificate_pem}"
}
