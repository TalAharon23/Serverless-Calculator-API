provider "aws" {
  region = "us-east-1"
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
  function_name = "SubscribedLambda"
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

# Create the API Gateway
resource "aws_api_gateway_rest_api" "calculator_api" {
  name = "ServerlessCalculatorAPI"
}

# Create a resource within the API Gateway
resource "aws_api_gateway_resource" "calculator_resource" {
  rest_api_id = aws_api_gateway_rest_api.calculator_api.id
  parent_id   = aws_api_gateway_rest_api.calculator_api.root_resource_id
  path_part   = "{proxy+}"
}

# Define a method for the resource
resource "aws_api_gateway_method" "calculator_method" {
  rest_api_id   = aws_api_gateway_rest_api.calculator_api.id
  resource_id   = aws_api_gateway_resource.calculator_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integrate the API Gateway method with the Lambda function
resource "aws_api_gateway_integration" "calculator_integration" {
  rest_api_id = aws_api_gateway_rest_api.calculator_api.id
  resource_id = aws_api_gateway_resource.calculator_resource.id
  http_method = aws_api_gateway_method.calculator_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.calculator_lambda.invoke_arn
}

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name              = "calculator-api.example.com"
  certificate_arn          = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-ab12-cd34-ef56-1234567890ab"
  security_policy          = "TLS_1_2"
}

resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
  domain_name = aws_api_gateway_domain_name.custom_domain.id
  rest_api_id = aws_api_gateway_rest_api.calculator_api.id
  stage_name  = "prod"
}


# Define a response for the method
resource "aws_api_gateway_method_response" "example_response" {
  rest_api_id = aws_api_gateway_rest_api.calculator_api.id
  resource_id = aws_api_gateway_resource.calculator_resource.id
  http_method = aws_api_gateway_method.calculator_method.http_method

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

# Define an integration response for the method
resource "aws_api_gateway_integration_response" "example_response" {
  rest_api_id = aws_api_gateway_rest_api.calculator_api.id
  resource_id = aws_api_gateway_resource.calculator_resource.id
  http_method = aws_api_gateway_method.calculator_method.http_method
  status_code = aws_api_gateway_method_response.example_response.status_code

  response_templates = {
    "application/json" = ""
  }
}
