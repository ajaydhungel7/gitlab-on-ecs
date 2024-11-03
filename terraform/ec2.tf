/*resource "aws_iam_role" "fargate_test_instance_role" {
  name = "fargate-test-instance"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_full_access" {
  name       = "attach_ecs_full_access"
  roles      = [aws_iam_role.fargate_test_instance_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# Security Group for EC2 instance
resource "aws_security_group" "fargate_test_sg" {
  name        = "fargate-test"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-xxxxxx"  # Replace with your VPC ID

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust IP range as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for GitLab Runner
resource "aws_instance" "gitlab_runner" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with the Ubuntu Server 18.04 AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnets["subnet1"].id  # Replace with your subnet ID
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.fargate_test_instance_profile.name
  security_groups      = [aws_security_group.fargate_test_sg.name]

  tags = {
    Name = "gitlab-runner-instance"
  }
}

# IAM Instance Profile for EC2 instance
resource "aws_iam_instance_profile" "fargate_test_instance_profile" {
  name = "fargate-test-instance-profile"
  role = aws_iam_role.fargate_test_instance_role.name
}

# Key Pair for SSH Access
resource "tls_private_key" "fargate_runner_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "fargate_runner_manager" {
  key_name   = "fargate-runner-manager"
  public_key = tls_private_key.fargate_runner_key.public_key_openssh
}

output "fargate_runner_private_key" {
  value     = tls_private_key.fargate_runner_key.private_key_pem
  sensitive = true
}

output "gitlab_runner_public_ip" {
  value = aws_instance.gitlab_runner.public_ip
}
*/