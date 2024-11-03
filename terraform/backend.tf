terraform {
  backend "s3" {
    bucket         = "state-bucket007"     # Replace with your S3 bucket
    key            = "gitlab/terraform.tfstate"  # Unique key for the state file
    region         = "us-east-1"               # Replace with your AWS region
    encrypt        = true
  }
}
