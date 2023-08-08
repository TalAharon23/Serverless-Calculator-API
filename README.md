# Serverless-Calculator-API

## Table of Contents

- [Prerequisites](#prerequisites)
- [Step 1: Configure AWS Resources](#step-1-configure-aws-resources)
- [Step 2: Deploy Terraform Script](#step-2-deploy-terraform-script)
- [Step 3: Interact with the API](#step-3-interact-with-the-api)
- [Conclusion](#conclusion)

## Prerequisites

Before you begin, make sure you have the following prerequisites in place:

1. **AWS Account:** You need an active AWS account. If you don't have one, you can sign up [here](https://aws.amazon.com/).
2. **Terraform:** Install Terraform by following the instructions in the [Terraform documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3. **Email Address:** Provide an email address for receiving subscription notifications from the API.

## Step 1: Configure AWS Resources

1. **IAM Role:** Log in to your AWS Management Console. Create an IAM role named `lambda_execution_role` with `lambda.amazonaws.com` as the trusted entity. Attach the `AWSLambdaBasicExecutionRole` policy to this role.

2. **SNS Topic:** Create an SNS topic named `SubscriptionSNS` in your AWS account. Provide your email address for email subscription.

3. **Lambda Function:** Create an AWS Lambda function named `SubscribedLambda` using the provided `calculator_lambda.zip` deployment package. Attach the `lambda_execution_role` IAM role to this function.

4. **Lambda Permission:** Configure the Lambda function to allow SNS to invoke it. Attach a policy to the `lambda_execution_role` to grant permissions for `sns:Publish` to the `SubscriptionSNS` topic.

5. **API Gateway:** Create an API Gateway named `ServerlessCalculatorAPI` in the AWS Management Console.

6. **API Gateway Resource and Method:** Create a resource and method (e.g., `GET`) within the API Gateway. Configure the integration to the `SubscribedLambda` Lambda function using the `AWS_PROXY` integration type.

7. **API Gateway Deployment:** Deploy the API to a stage (e.g., `prod`) within the API Gateway.

8. **Custom Domain:** If desired, configure a custom domain for the API Gateway using an ACM certificate.

## Step 2: Deploy Terraform Script

1. **Clone Repository:** Clone this repository to your local machine.

2. **Navigate to Directory:** Open a terminal and navigate to the directory containing the Terraform files.

3. **Edit Variables:** Open the `variables.tf` file and modify the variables as needed. Ensure that the `region`, `lambda_function_name`, `endpoint_path`, and other variables match your AWS configuration.

4. **Initialize Terraform:** Run `terraform init` to initialize Terraform.

5. **Plan and Apply:** Run `terraform plan` to preview the changes, and then run `terraform apply` to apply the changes. Confirm the changes when prompted.

## Step 3: Interact with the API

1. **Access the HTML Interface:** Open the `index.html` file in a web browser. You will see an interface to input numbers and generate the API URL.

2. **Generate API URL:** Enter two numbers and click the "Click for result!" button. The API URL and calculated result will be displayed.

3. **Invoke API:** Open the generated API URL in a browser or use tools like `curl` or `Postman` to send GET requests with the `num1` and `num2` parameters. You will receive a JSON response with the calculated result.

## Conclusion

You have successfully set up and used the Serverless Calculator API environment. This guide walked you through configuring AWS resources, deploying the Terraform script, and interacting with the API through the HTML interface and direct requests. You can now extend and customize this environment for your specific use cases and explore more AWS features and services.
