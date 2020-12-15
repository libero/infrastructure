resource "aws_iam_role" "iam_for_lambda" {
  name = "notifySlackFromLogFilter-role-tt8g709j"
  path = "/service-role/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "lambda_execution_role" {
  name = "AWSLambdaBasicExecutionRole-7da66599-6f16-4e35-b958-e5a159395b10"
  path = "/service-role/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "logs:CreateLogGroup",
          "Resource": "arn:aws:logs:us-east-1:540790251273:*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ],
          "Resource": [
              "arn:aws:logs:us-east-1:540790251273:log-group:/aws/lambda/notifySlackFromLogFilter:*"
          ]
      }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_execution_role.arn
}

data "archive_file" "lambda_src" {
  type             = "zip"
  source_dir = "${path.module}/notifySlackFromLogFilter"
  output_path      = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "notify" {
  filename      = data.archive_file.lambda_src.output_path
  function_name = "notifySlackFromLogFilter"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda_src.output_base64sha256

  runtime = "nodejs12.x"

  environment {
    variables = {
      SLACK_WEBHOOK_PATH = var.slack_webhook_path
    }
  }
}

resource "aws_cloudwatch_log_subscription_filter" "notify_slack_lambda_on_errors" {
  name            = "error_on_sciety_prod"
  log_group_name  = "/aws/containerinsights/libero-eks--franklin/application"
  filter_pattern  = "{ ($.app_level = \"error\") && ($.kubernetes.pod_name = \"sciety--prod*\") }"
  destination_arn = aws_lambda_function.notify.arn
}
