resource "aws_ecs_cluster" "gitlab_cluster" {
  name = "gitlab-runner-cluster"
}

# Create an ECR Repository
resource "aws_ecr_repository" "gitlab_runner_repo" {
  name                 = "gitlab-runner-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "gitlab-runner-ecr"
  }
}

# Output the repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.gitlab_runner_repo.repository_url
  description = "The URL of the ECR repository"
}


# ECS Task Definition
resource "aws_ecs_task_definition" "gitlab_task" {
  family                   = "gitlab-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn = "arn:aws:iam::544234170512:role/ecsTaskExecutionRole"
  task_role_arn = aws_iam_role.ecs_task_role.arn


  container_definitions = jsonencode([
    {

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "gitlab"
          "awslogs-region"       = "us-east-1"          # Replace with your region
          "awslogs-stream-prefix" = "gitlab" # Replace with your desired prefix
        }
      }
      health_check = {
        command     = ["CMD-SHELL", "curl -f 0.0.0.0:80/-/health || exit 1"]
        interval    = 30                # Time (in seconds) between health checks
        timeout     = 5                 # Time (in seconds) to wait for a response
        retries     = 3                 # Number of times to retry before marking the container as unhealthy
        start_period = 10                # Time (in seconds) to wait after the container starts before beginning health checks
      }


      name      = "gitlab-CE"
      image     = "544234170512.dkr.ecr.us-east-1.amazonaws.com/gitlab-runner-repo:8"  # Use the GitLab CE image from Docker Hub or ECR
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 443
          hostPort      = 443
        },
        {
          containerPort = 22
          hostPort      = 22
        }
      ]

       mountPoints = [
        {
          containerPath = "/etc/gitlab"
          sourceVolume  = "efs-shared"
        },
        {
          containerPath = "/var/opt/gitlab"
          sourceVolume  = "efs-shared"
        },
        {
          containerPath = "/var/log/gitlab"
          sourceVolume  = "efs-shared"
        }
      ]
       

     depends_on = [
    aws_lb.gitlab_lb,
    aws_db_instance.gitlab_rds
  ]
    }
  ])

  volume {
    name = "efs-shared"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.gitlab_efs.id  # EFS file system ID for /etc/gitlab
      transit_encryption = "ENABLED"   # Optional, enables encryption in transit
    }
  }

}



# ECS Service
resource "aws_ecs_service" "gitlab_runner_service" {
   name            = "gitlab-service"
   cluster         = aws_ecs_cluster.gitlab_cluster.id
  task_definition = aws_ecs_task_definition.gitlab_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         =  [for subnet in aws_subnet.public_subnets : subnet.id]
    security_groups = [aws_security_group.gitlab_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.gitlab_tg.arn
    container_name   = "gitlab-CE"
    container_port   = 80
  }

  depends_on = [aws_lb.gitlab_lb]
}

/*
# Auto Scaling Group and Launch Configuration
resource "aws_launch_configuration" "gitlab_runner_lc" {
  name          = "gitlab-runner-lc"
  image_id      = aws_instance.gitlab_runner.ami  # Use the same AMI as your EC2 instance
  instance_type = aws_instance.gitlab_runner.instance_type
  iam_instance_profile = aws_iam_instance_profile.fargate_test_instance_profile.id
  key_name = aws_key_pair.fargate_runner_manager.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "gitlab_runner_asg" {
  launch_configuration = aws_launch_configuration.gitlab_runner_lc.id
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.subnets["subnet1"].id,aws_subnet.subnets["subnet2"].id]
}

*/

resource "aws_security_group" "gitlab_sg" {
  vpc_id = aws_vpc.gitlab_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gitlab-sg"
  }
}



resource "aws_lb_target_group" "gitlab_tg" {
  name     = "gitlab-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.gitlab_vpc.id
  target_type = "ip" 

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    port                = "80"
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ECRAccessPolicy"
  description = "Policy to allow ECS tasks to pull images from ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",            # Allows getting the authorization token for ECR
          "ecr:BatchCheckLayerAvailability",        # Allows checking if layers are available
          "ecr:GetDownloadUrlForLayer",             # Allows getting the download URL for layers
          "ecr:BatchGetImage"                       # Allows getting images from ECR
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:DescribeRepositories",                # Allows describing ECR repositories
          "ecr:ListImages",                          # Allows listing images in a repository
          "ecr:DescribeImages"                       # Allows describing images in a repository
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_execution_default_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_efs_file_system" "gitlab_efs" {
  creation_token   = "gitlab-efs-token"
  performance_mode = "generalPurpose"  # Options: generalPurpose, maxIO
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"  # Move files to Infrequent Access after 30 days
  }
  tags = {
    Name = "gitlab-efs"
  }
}

# Security group for EFS
resource "aws_security_group" "gitlab_efs_sg" {
  name        = "gitlab-efs-security-group"
  description = "Security group for GitLab EFS access"
  vpc_id      = aws_vpc.gitlab_vpc.id # Specify your VPC ID

  # Allow inbound NFS traffic (port 2049)
  ingress {
    from_port   = 2049
    to_port     = 2049
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


resource "aws_efs_mount_target" "gitlab_efs_mt" {
  for_each        = aws_subnet.public_subnets
  file_system_id  = aws_efs_file_system.gitlab_efs.id
  subnet_id       = each.value.id
  security_groups = [aws_security_group.gitlab_efs_sg.id]
}

# ECS Task Role with full permissions to S3, ElastiCache, CloudWatch, and others
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role_with_full_permissions"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# Policy granting full access to S3, ElastiCache, CloudWatch, and additional services
resource "aws_iam_policy" "ecs_task_role_full_access_policy" {
  name   = "ecs_task_role_full_access_policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:*",
          "elasticache:*",
          "cloudwatch:*",
          "logs:*",                # CloudWatch Logs
          "cloudwatch:PutMetricData",
          "dynamodb:*",            # DynamoDB as an example for additional services
          "secretsmanager:*"       # Secrets Manager (if required)
        ],
        "Resource": "*"
      }
    ]
  })
}