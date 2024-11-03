variable "aws_region" {
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
}


variable "db_username" {
  description = "Database username for GitLab"
  default     = "gitlab"
}

variable "db_password" {
  description = "Database password for GitLab"
  default     = "your_db_password"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # Example CIDR block
}

variable "public_subnet_cidrs" {
  description = "Map of CIDR blocks for a private subnet for RDS"
  type        = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    public_subnet1 = {
      cidr_block = "10.0.3.0/24"
      az         = "us-east-1b"
    }
     public_subnet2 = {
      cidr_block = "10.0.5.0/24"
      az         = "us-east-1c"
    }
  }
}

variable "private_subnet_cidrs" {
  description = "Map of CIDR blocks for a private subnet for RDS"
  type        = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    private_subnet1 = {
      cidr_block = "10.0.4.0/24"
      az         = "us-east-1c"
    }
     private_subnet2 = {
      cidr_block = "10.0.7.0/24"
      az         = "us-east-1b"
    }
  }
}

