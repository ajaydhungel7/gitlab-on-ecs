output "ecs_cluster_name" {
  value = aws_ecs_cluster.gitlab_cluster.name
}



output "s3_bucket_name" {
  value = aws_s3_bucket.gitlab_bucket.bucket
}

# Output the repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.gitlab_runner_repo.repository_url
  description = "The URL of the ECR repository"
}
