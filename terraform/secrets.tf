/*
resource "aws_secretsmanager_secret" "gitlab_db_secret" {
  name = "gitlab-db-secret"
  
  tags = {
    Name = "GitLabDBSecret"
  }
}

resource "aws_secretsmanager_secret_version" "gitlab_db_secret_value" {
  secret_id = aws_secretsmanager_secret.gitlab_db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.gitlab_rds.endpoint
    port     = "5432"
  })
}

resource "aws_iam_role_policy" "secrets_access_policy" {
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"],
        Effect   = "Allow",
        Resource = aws_secretsmanager_secret.gitlab_db_secret.arn
      }
    ]
  })
}

*/