output "ecs_cluster_name" {
  value = aws_ecs_cluster.gitlab_cluster.name
}



output "s3_bucket_name" {
  value = aws_s3_bucket.gitlab_bucket.bucket
}
