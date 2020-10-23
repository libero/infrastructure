data "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_iam_role_policy" "dns_update" {
  role = var.role_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${data.aws_route53_zone.main.zone_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "helm_release" "external_dns" {
  name = "external-dns"
  chart = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version = "2.19.0"
  namespace = var.namespace

  set {
    name  = "sources[0]"
    value = "service"
  }

  set {
    name  = "sources[1]"
    value = "ingress"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "zoneIdFilters[0]"
    value = data.aws_route53_zone.main.zone_id
  }

  set {
    name  = "txtOwnerId"
    value = var.owner_id
  }

  set {
    name = "txtPrefix"
    value = "external-dns."
  }
}
