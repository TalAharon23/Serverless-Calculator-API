# Serverless-Calculator-API

## Table of Contents

- [Prerequisites](#prerequisites)
- [Step 1: Setting Up AWS Account in VS Code Terminal](#step-1-setting-up-aws-account-in-vs-code-terminal)
- [Step 2: Deploy Terraform Script](#step-2-deploy-terraform-script)
- [Step 3: Interact with the API](#step-3-interact-with-the-api)
- [Cleanup](#cleanup)
- [Summary](#summary)

## Prerequisites

Before you begin, make sure you have the following prerequisites in place:

1. **AWS Account:** You need an active AWS account. If you don'tr have one, you can sign up [here](https://aws.amazon.com/).
2. **Terraform:** Install Terraform by following the instructions in the [Terraform documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3. **Email Address:** Provide an email address for receiving subscription notifications from the API.


## Step 1: Setting Up AWS Account in VS Code Terminal

Follow these steps to configure your AWS credentials in the Visual Studio Code (VS Code) terminal using the AWS Command Line Interface (CLI).

### Install and configure AWS CLI

1. If you haven't already, install the AWS CLI on your computer. You can download and install it from the official AWS CLI documentation: [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

2. Run the following command to configure your AWS credentials. Replace `<YOUR_ACCESS_KEY>` and `<YOUR_SECRET_KEY>` with your actual AWS access key and secret key. Also, specify the desired default region.

   ```sh
   aws configure
   ```


## Step 2: Deploy Terraform Script

1. **Clone Repository:** Clone this repository to your local machine.

2. **Navigate to Directory:** Open a terminal and navigate to the directory containing the Terraform files.

3. **Edit Variables:** Open the `variables.tf` file and modify the variables as needed. Ensure that the `region`, `lambda_function_name`, `endpoint_path`, `mail_endpoint`, and other variables match your AWS configuration.
 ' 
4. **Initialize Terraform:** Run `terraform init` to initialize Terraform.

5. **Plan and Apply:** Run `terraform plan` to preview the changes, and then run `terraform apply` to apply the changes. Confirm the changes when prompted.

## Step 3: Interact with the API
First of all get the URL provided:

Step 1: Log into the AWS Console.

Step 2 :  Go to the API Gateway console.

Step 3: Click on the API name.

Step 4: Find the Deploy section in the left panel.

Step 5: Click on stage. Select the stage `dev`. The stage details on the right side will include the “Invoke URL”

1. **Access via browser**: Open your browser  with the URL and the relevant parameters.
e.g: 
```sh
https://zsq1s6pns6.execute-api.us-east-1.amazonaws.com/dev/calculator?num1=3&num2=8
```
The result will be:


{"result": 11}


Also, you will get a notice in your mail (:

2. **Invoke API:** Open the generated API URL in a browser or use tools like `curl` or `Postman` to send GET requests with the `num1` and `num2` parameters. You will receive a JSON response with the calculated result.

**Coming soon: Access the HTML Interface:** Open the `index.html` file in a web browser. You will see an interface to input numbers and generate the API URL

## Cleanup
To clean up and remove deployed resources, run:
```sh
terraform destroy
```

## Summary

You have successfully set up and used the Serverless Calculator API environment. This guide walked you through configuring AWS resources, deploying the Terraform script, and interacting with the API through the HTML interface and direct requests. 


