variable "region" {
    description = "AWS region to deploy"
    type        = string
    default     = "us-east-1"
}

variable "accountId" {
    description = "AWS account ID"
    type        = string
    default     = "133318666765"
}

variable "lambda_function_name" {
    description = "Name of the lambda function"
    type        = string
    default     = "CalculatorLambda"
}

variable "endpoint_path" {
    description = "The GET endpoint path"
    type        = string
    default     = "calculator"
}