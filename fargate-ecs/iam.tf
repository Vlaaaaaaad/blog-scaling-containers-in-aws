data "aws_iam_policy_document" "fargate_tasks" {
  # AWS ECR Image Pulling permissions
  statement {
    sid = "ecrtoken"

    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*"
    ]
  }
  statement {
    sid = "ecrget"

    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = [
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/hello-repo-eu",
    ]

    # Force pulling over VPC Endpoint
    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpc"
      values   = ["${module.vpc.vpc_id}"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpce"
      values   = ["${module.vpc.vpc_endpoint_ecr_dkr_id}"]
    }
  }

  # CloudWatch
  statement {
    sid = "cwlogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "workers" {
  name        = "eks-workers-${local.cluster_name}-${data.aws_region.current.name}"
  description = "IAM permissions necessary for Fargate on ECS Tasks"

  policy = data.aws_iam_policy_document.fargate_tasks.json
}

resource "aws_iam_role_policy_attachment" "attach_permissions_workers_one" {
  role       = module.one.task_role_name
  policy_arn = aws_iam_policy.workers.arn
}

resource "aws_iam_role_policy_attachment" "attach_permissions_workerst_wo" {
  role       = module.two.task_role_name
  policy_arn = aws_iam_policy.workers.arn
}

resource "aws_iam_role_policy_attachment" "attach_permissions_workers_three" {
  role       = module.three.task_role_name
  policy_arn = aws_iam_policy.workers.arn
}

resource "aws_iam_role_policy_attachment" "attach_permissions_workers_andahalf" {
  role       = module.andahalf.task_role_name
  policy_arn = aws_iam_policy.workers.arn
}
