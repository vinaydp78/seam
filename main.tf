provider "aws" {
  region = "eu-west-1"  # replace with the region you want to use
}


# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}


# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  #availability_zone = "eu-west-1" # replace with the AZ you want to use
}

# Create routing table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # Replace with the ID of the NAT Gateway that you want to use
    # to allow traffic to reach the internet
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Create Lambda function
resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my-lambda-function"
  handler = "index.handler"
  runtime = "nodejs14.x"
  role = aws_iam_role.lambda_execution_role.arn
  # replace with your lambda function code
  filename = "api_vinay.zip"

  #vpc_config {
   # security_group_ids = [aws_security_group.my_security_group.id]
    #subnet_ids         = [aws_subnet.private_subnet.id]
  #}
}

# Create security group
resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group"
  description = "Security group for my Lambda function"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}

# Attach security group to Lambda function
#resource "aws_lambda_function" "my_lambda_function" {
  #security_group_ids = aws_security_group.my_security_group.id
#}

# Create IAM role for Lambda function
resource "aws_iam_role" "lambda_execution_role" {
  name = "my-lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "my-lambda-execution-role"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.private_subnet.id
}

resource "aws_instance" "example" {
  ami = "ami-005f9685cb30f234b"
  #ami = data.aws_ami.example.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "example-instance"
  }
}


resource "aws_eip_association" "example" {
  instance_id   = aws_instance.example.id
  allocation_id = aws_eip.example.id
}

resource "aws_eip" "example" {
  vpc      = true
  tags = {
    Name = "vinay"
  }
}


resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "vinay"
  }
}
