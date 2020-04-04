data "aws_iam_policy_document" "fargate_assume_role_policy" {
  statement {
    sid = "EKSFargateAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "eks-fargate-pods.amazonaws.com"
      ]
    }
  }
}

resource "aws_eks_fargate_profile" "workers" {
  fargate_profile_name = local.cluster_name

  cluster_name           = module.eks.cluster_id
  pod_execution_role_arn = aws_iam_role.fargate.arn
  subnet_ids             = module.vpc.private_subnets

  selector {
    namespace = "fargate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "fargate" {
  name = "fargate-eks-workers-${local.cluster_name}-${data.aws_region.current.name}"

  assume_role_policy    = data.aws_iam_policy_document.fargate_assume_role_policy.json
  force_detach_policies = true

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "fargate_AmazonEKSFargatePodExecutionRolePolicy" {
  role       = aws_iam_role.fargate.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "attach_permissions_fargate_workers" {
  role       = aws_iam_role.fargate.name
  policy_arn = aws_iam_policy.workers.arn
}
