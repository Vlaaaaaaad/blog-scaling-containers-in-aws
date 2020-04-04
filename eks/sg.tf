resource "aws_security_group" "vpc_endpoints_in_n_out" {
  name = format("%.255s", "ednpoints_${local.cluster_name}")
  description = format(
    "%.255s",
    "Terraform-managed SG for VPC Endpoints in ${local.cluster_name}",
  )
  vpc_id = module.vpc.vpc_id

  tags = merge(
    local.common_tags,
    {
      "Name" = "endpoints-${local.cluster_name}"
    },
  )
}

resource "aws_security_group_rule" "endpoints_eks_in" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from VPC Endpoints to EKS Control Plane"

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.eks.cluster_security_group_id
}

resource "aws_security_group_rule" "endpoints_eks_out" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from EKS Control Plane to VPC Endpoints"

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.eks.cluster_security_group_id
}

resource "aws_security_group_rule" "endpoints_nodes_in" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from VPC Endpoints to EKS Workers"

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.eks.worker_security_group_id
}

resource "aws_security_group_rule" "endpoints_nodes_out" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from EKS Workers to VPC Endpoints"

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.eks.worker_security_group_id
}
