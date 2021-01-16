terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

## prepare lambda code
resource "null_resource" "package" {
  provisioner "local-exec" {
    working_dir = "${path.module}/../"
    command = "yarn && yarn compile"
  }
  triggers = {
    run_every_time = uuid()
  }
}

data "archive_file" "lambda" {
  type = "zip"
  source_dir = "${path.module}/../dist"
  output_path = "${path.module}/../function.zip"

  depends_on = [null_resource.package]
}

# lambda log group
resource "aws_cloudwatch_log_group" "logs" {
  name = "/aws/lambda/${var.function_name}"
  retention_in_days = 90
}

# lambda execution role
resource "aws_iam_role" "execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
                        "Service": "lambda.amazonaws.com"
                    }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.execution_role.name
}

# lambda function
resource "aws_lambda_function" "function" {
  function_name = var.function_name
  handler = "index.handler"
  role = aws_iam_role.execution_role.arn
  runtime = "nodejs12.x"

  filename = data.archive_file.lambda.output_path

  depends_on = [data.archive_file.lambda]
}
