
variable "db_subnet_group_name" {
  description = "The name of the DB subnet group."
  default     = "gitlab-db-subnet-group"
}

resource "aws_db_instance" "gitlab_rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.medium"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres15"
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.gitlab_rds_sg.id]
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.gitlab_db_subnet_group.name
  

  tags = {
    Name = "gitlab-rds-postgres"
  }

  depends_on = [ aws_security_group.gitlab_rds_sg ]
}

resource "aws_db_subnet_group" "gitlab_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    Name = var.db_subnet_group_name
  }
}

resource "aws_security_group" "gitlab_rds_sg" {
  vpc_id = aws_vpc.gitlab_vpc.id

  // Inbound rule allowing access to the PostgreSQL port from your application
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.gitlab_vpc.cidr_block]  // Replace with the CIDR block of your application
  }

  // Outbound rule to allow traffic out (default allows all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // All traffic
    cidr_blocks = ["0.0.0.0/0"] // Change to specific CIDR if needed
  }

  tags = {
    Name = "gitlab-rds-sg"
  }
}
