resource "aws_s3_bucket" "gitlab_bucket" {
  bucket = "gitlab-backups-bucket789"

}

resource "random_string" "suffix" {
  length  = 6
  special = false
}

resource "aws_iam_role" "s3_gitlab_access_role" {
  name = "s3-gitlab-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_gitlab_access_policy" {
  role = aws_iam_role.s3_gitlab_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
      Effect = "Allow"
      Resource = [
        aws_s3_bucket.gitlab_bucket.arn,
        "${aws_s3_bucket.gitlab_bucket.arn}/*"
      ]
    }]
  })
}
