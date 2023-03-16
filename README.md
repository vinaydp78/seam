# devops-candidate-exam

Dear Candidate, 

In this hands-on exam we are going to test your knowledge and capabilities in the following topics,

- Jenkins
  - Declarative Pipeline
  - General Configuration
- Git
- Terraform
- AWS
- Coding (Preferred Python)

## Exercise Details

You are going to create a small infrastructure on AWS using Terraform.
Your Terraform code will cover the creation of:

* Private Subnet
* Routing Table
* Lambda Function
  * Security Group

We will provide the *VPC ID*, *NAT Gateway ID*, *Lambda IAM Role & Policy*. \
Check the [data.tf](https://github.com/jerasioren/devops-candidate-exam/blob/main/data.tf) for reference to those resources.

Once your Terraform code is ready you'll be able to test it via a Jenkins pipeline that will execute it. \
A Jenkins URL will be provided to you.

**Note to mention** that you may use the internet to complete your exercise.

The end goal of this exercise is to invoke your Lambda function against a remote API that receives a specific payload and to get a valid HTTP 200 return code status. \
Our remote API will send us an email with the relevant information from your exercise. \
When you reach to this state, please let the instructor know about it so we can check it on our end.

## Instructions

### Preparing your working environment 

* **Clone** this repository to your local machine and then update the git origin to point your own GitHub account repository. Repository should be publicly accessible. \
  Example,
    ```
    git remote set-url origin https://github.com/<GitHub Account>/devops-candidate-exam.git
    ```
  * We are requesting not to *fork* the project since other candidates will be able to view your results.
  * In case you are having trouble to modify the code locally and push it to GitHub via SSH, try using the HTTPS origin or upload your modified files via the GitHub Web UI.
* Make sure you are able to access the Jenkins UI using the link you got.
* You'll be able to run the Terraform code only via the Jenkins pipeline, so make sure to download the Terraform executable to the Jenkins machine. 
    * You can create a playground pipeline to download the executable using shell commands
    * No need to specify permission, Jenkins is running under AWS account with IAM role attached to it.

### **Terraform**

Use the following details to configure the AWS provider configuration. Pay attention that we are using S3 backend. 

```
S3 Bucket: "3.devops.candidate.exam"
Region: "eu-west-1"
Key: "<Your First Name>.<You Last Name>"
```

Once you have created your S3 backend config you may try to perform Terraform init. \
***NOTE**: Terraform init or any AWS CLI command can be executed only from the Jenkins pipeline.*

For the **Subnet** CIDR block please use the following:
```
10.0.1.0/24
10.0.2.0/24
10.0.3.0/24
10.0.4.0/24
...
...
10.0.254.0/24
```
The VPC CIDR block is `10.0.0.0/16`. \
We do not have any preference regarding the availability zone for the subnet.

#### **Lambda Code**

You should write code that will invoke a remote API endpoint. \
You may use any language you wish, although we preferred it to be python.

Your Lambda function should:
- Run under your private subnet you have created.
- Post a request to the following HTTPS endpoint:
`https://2xfhzfbt31.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data`
  - You should use the following security header for the request to pass: \
  `{'X-Siemens-Auth': 'test'}` 
  - The data payload must be as followed:
    ```json
    payload = {
      "subnet_id": "<Your Private Subnet ID>",
      "name": "<Your Full Name>",
      "email": "<Your Email Address>"
    }
    ```
    You should use real values in the payload.

`Tip:` When you'r invoking your Lambda from the CLI, remember to add the following argument to the command **"--log-type Tail"**. This will return your **"LogResult"** which contain your actual post response in a base 64 format. You will need to convert it in order to view the actual endpoint response. \
Return code example:
```json
{
    "StatusCode": 200,
    "LogResult": "U1RBUlQgUmVxdWVzdElkOiAyMjVjNTNmZC1hYTg0LTQwMzgtODA0OS1iYTYwN2M5ZmZjMWQgVmVyc2lvbjogJExBVEVTVAp7Im1lc3NhZ2UiOiAiTWVzc2FnZSBwcm9jZXNzZWQgc3VjY2Vzc2Z1bGx5LiJ9CjIwMApFTkQgUmVxdWVzdElkOiAyMjVjNTNmZC1hYTg0LTQwMzgtODA0OS1iYTYwN2M5ZmZjMWQKUkVQT1JUIFJlcXVlc3RJZDogMjI1YzUzZmQtYWE4NC00MDM4LTgwNDktYmE2MDdjOWZmYzFkCUR1cmF0aW9uOiAyODY1LjA2IG1zCUJpbGxlZCBEdXJhdGlvbjogMjg2NiBtcwlNZW1vcnkgU2l6ZTogMTI4IE1CCU1heCBNZW1vcnkgVXNlZDogNDkgTUIJSW5pdCBEdXJhdGlvbjogMzQzLjUxIG1zCQo=",
    "ExecutedVersion": "$LATEST"
}
```
### **Jenkins**

Use the `Jenkinsfile` provided in this repository to init, plan, apply and invoke your Lambda function.

Create a new jenkins pipeline job and configure it to pull your forked project from GitHub.

Create an additional pipeline, not from source code, to download the Terraform and AWS CLI executables that you will need in order to complete your exercise.

**Remember**, the end goal in the Jenkins is that you will have a fully working pipeline that creates/synchronizes the infrastructure and to invoke your Lambda in the final stage. \
Your Jenkins have the required IAM role to allow you to build your Terraform code and to invoke your Lambda. 

***NOTE**: you are running inside a container without a persistent storage. Please avoid restarting your Jenkins, as this would cause you to start from scratch.

`Bonus Point`: Automatically convert the Lambda base64 response and write them to the console output in Jenkins.

## Good Luck!
