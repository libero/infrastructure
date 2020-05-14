data "helm_repository" "incubator" {
  name = "incubator"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

# could actually be limited to only creating logs, 
# but it's difficult to find a standard policy that covers
# all the actions that the CloudWatch agent may use
resource "aws_iam_role_policy" "logs_full_access" {
  role = var.role_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

data "aws_region" "current" {}

data "template_file" "amazon_cloudwatch_container_insights_raw_helm_chart_values" {
  template = "${file("${path.module}/cwagent-fluentd-quickstart.yaml.tpl")}"
  vars = {
    cluster_name = "${var.cluster_name}"
    region_name = "${data.aws_region.current.name}"
  }
}


resource "helm_release" "amazon_cloudwatch_container_insights" {
  name = "amazon-cloudwatch-container-insights"
  chart = "raw"
  repository = data.helm_repository.incubator.metadata[0].name
  version = "0.2.3"
  values = [data.template_file.amazon_cloudwatch_container_insights_raw_helm_chart_values.rendered]
  #    "values": {}[
  #      "templates:\n- |\n  apiVersion: v1\n  kind: ConfigMap\n  metadata:\n    name: hello-world\n"
  #    ],
  #  },
}
