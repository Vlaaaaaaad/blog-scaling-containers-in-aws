data "aws_iam_policy_document" "ecr_pull_n_push_current_account" {
  provider = aws.us
  version  = "2008-10-17"

  # Allow everything in the current account
  #  to pull images from the repo
  statement {
    sid    = "Get"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]
  }

  # Allow everything in the current account
  #  to push images from the repo
  statement {
    sid    = "Push"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}
