

resource "aws_elasticache_subnet_group" "gitlab_redis_group" {
  name       = "gitlab-redis-group"
   subnet_ids = [for subnet in aws_subnet.public_subnets : subnet.id]
  tags = {
    Name = "GitLab Redis Subnet Group"
  }
}


resource "aws_security_group" "gitlab_redis_sec_group" {
  name        = "gitlab-redis-sec-group"
  description = "Security group for GitLab Redis"
  vpc_id      = aws_vpc.gitlab_vpc.id # Replace with your VPC ID

  // Add ingress and egress rules as needed

   ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Adjust CIDR as needed
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_elasticache_cluster" "gitlab_redis" {
  cluster_id           = "gitlab-redis"
  engine               = "redis"
  engine_version       = "7.1"  # Replace with the specific version needed for your GitLab
  node_type            = "cache.t3.medium"  # Adjust according to your needs
  port                 = 6379
  parameter_group_name = "default.redis7" # Replace with the appropriate parameter group name
  subnet_group_name    = aws_elasticache_subnet_group.gitlab_redis_group.name
  security_group_ids   = [aws_security_group.gitlab_redis_sec_group.id]
  num_cache_nodes      = 1
  
  
 
  tags = {
    Name = "GitLab Redis"
  }

  depends_on = [
    aws_elasticache_subnet_group.gitlab_redis_group,
    aws_security_group.gitlab_redis_sec_group
  ]
}