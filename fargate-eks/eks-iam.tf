data "aws_iam_policy_document" "policy_doc" {
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
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/test-repo",
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

  # AWS EC2 Autoscaling permissions
  # Copied from https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws
  statement {
    sid = "clusterautoscaler"

    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  # CloudWatch Container Insights
  # copied from arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
  statement {
    sid = "cloudwatchput"

    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
    ]

    resources = ["*"]
  }
  statement {
    sid = "cloudwatchgetparam"

    effect = "Allow"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*",
    ]
  }
}

resource "aws_iam_policy" "workers" {
  name        = "eks-workers-${local.cluster_name}-${data.aws_region.current.name}"
  description = "A policy that gives IAM rights to EKS worker nodes"

  policy = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_role_policy_attachment" "attach_permissions_workers" {
  role       = module.eks.worker_iam_role_name
  policy_arn = aws_iam_policy.workers.arn
}
