resource "aws_ecr_repository" "eu" {
  provider = aws.eu

  name = "test-repo"

  tags = local.common_tags
}

resource "aws_ecr_repository_policy" "eu" {
  provider = aws.eu

  repository = aws_ecr_repository.eu.name
  policy     = data.aws_iam_policy_document.ecr_pull_n_push_current_account.json
}

resource "aws_ecr_repository" "us" {
  provider = aws.us

  name = "test-repo"

  tags = local.common_tags
}

resource "aws_ecr_repository_policy" "us" {
  provider = aws.us

  repository = aws_ecr_repository.us.name
  policy     = data.aws_iam_policy_document.ecr_pull_n_push_current_account.json
}
