provider "aws" {
  region = var.region
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "calculator_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = "calculator_lambda.lambda_handler"
  runtime       = "python3.8"
  filename      = "calculator_lambda.zip"
}

resource "aws_sns_topic" "subscription_sns" {
  name = "SubscriptionSNS"
}

resource "aws_lambda_permission" "sns_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.calculator_lambda.function_name
  principal     = "sns.amazonaws.com"

  source_arn = aws_sns_topic.subscription_sns.arn
}

resource "aws_iam_role_policy" "lambda_sns_publish_policy" {
  name   = "lambda_sns_publish_policy"
  role   = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "sns:Publish",
        Effect   = "Allow",
        Resource = aws_sns_topic.subscription_sns.arn
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.subscription_sns.arn
  protocol  = "email"
  endpoint  = "Tal.Aharon97@gmail.com"
}

########## API GATEWAY ##########

resource "aws_api_gateway_rest_api" "calculator_apigw" {
  name = "ServerlessCalculatorAPI"
}

resource "aws_api_gateway_resource" "apigw_resource" {
  rest_api_id = aws_api_gateway_rest_api.calculator_apigw.id
  parent_id   = aws_api_gateway_rest_api.calculator_apigw.root_resource_id
  path_part   = var.endpoint_path
}

resource "aws_api_gateway_method" "apigw_method" {
  rest_api_id   = aws_api_gateway_rest_api.calculator_apigw.id
  resource_id   = aws_api_gateway_resource.apigw_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.calculator_apigw.id
  resource_id             = aws_api_gateway_resource.apigw_resource.id
  http_method             = aws_api_gateway_method.apigw_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.calculator_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.calculator_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.calculator_apigw.id}/*/${aws_api_gateway_method.apigw_method.http_method}${aws_api_gateway_resource.apigw_resource.path}"
}

resource "aws_api_gateway_deployment" "apigw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.calculator_apigw.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.calculator_apigw.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.apigw_method, aws_api_gateway_integration.integration]
}

resource "aws_api_gateway_stage" "apigw_stage" {
  deployment_id = aws_api_gateway_deployment.apigw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.calculator_apigw.id
  stage_name    = "dev"
}
