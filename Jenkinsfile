pipeline{
    agent any
    stages{
        stage("TF Init"){
            steps{
               //sh "curl https://2xfhzfbt31.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data"
               //sh "yum install -y yum-utils "
               //sh "yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo"
               //sh "yum -y install terraform"
               sh "terraform -version"
               sh "terraform init"
            }
        }
        stage("TF Plan"){
            steps{
                sh "terraform plan"
            }
        }
        stage("TF Apply"){
            steps{
               sh "terraform apply --auto-approve"
            }
        }
        stage("Invoke Lambda"){
            steps{
               echo "lambda"
               //sh "aws lambda invoke  --function-name my-lambda-function"
                sh "aws lambda invoke --function-name my-lambda-function --cli-binary-format raw-in-base64-out --payload '{}' out.txt"
            }
        }
    }
}

