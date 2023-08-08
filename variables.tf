variable "region" {
    description = "AWS region to deploy"
    type        = string
    default     = "us-east-1"
}

variable "accountId" {
    description = "AWS account ID"
    type        = string
    default     = "133318666765" # Change to your AWS account ID.
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

variable "mail_endpoint" {
    description = "The mail endpoint"
    type        = string
    default     = "eranz@cloudbuzz.co.il" # According to the assignment.
}
