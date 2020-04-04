output "repo_name_us" {
  description = "Repository URL for the us-east-1 ECR"
  value = aws_ecr_repository.us.repository_url
}

output "repo_name_eu" {
  description = "Repository URL for the eu-west-1 ECR"
  value = aws_ecr_repository.eu.repository_url
}
