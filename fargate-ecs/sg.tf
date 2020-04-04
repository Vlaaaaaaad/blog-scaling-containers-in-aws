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

resource "aws_security_group_rule" "endpoints_ecs_in_one" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from VPC Endpoints to ECS tasks in the One Service"

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.one.service_sg_id
}

resource "aws_security_group_rule" "endpoints_ecs_out_one" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from ECS tasks in the One Service to VPC Endpoints"

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.one.service_sg_id
}

resource "aws_security_group_rule" "endpoints_ecs_in_two" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from VPC Endpoints to ECS tasks in the Two Service"

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.two.service_sg_id
}

resource "aws_security_group_rule" "endpoints_ecs_out_two" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from ECS tasks in the Two Service to VPC Endpoints"

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.two.service_sg_id
}

resource "aws_security_group_rule" "endpoints_ecs_in_three" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from VPC Endpoints to ECS tasks in the Three Service"

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.three.service_sg_id
}

resource "aws_security_group_rule" "endpoints_ecs_out_three" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from ECS tasks in the Three Service to VPC Endpoints"

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.three.service_sg_id
}

resource "aws_security_group_rule" "endpoints_ecs_in_half" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from VPC Endpoints to ECS tasks in the AndAHalf Service"

  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.andahalf.service_sg_id
}

resource "aws_security_group_rule" "endpoints_ecs_out_half" {
  security_group_id = aws_security_group.vpc_endpoints_in_n_out.id
  description       = "Allow traffic from ECS tasks in the AndAHalf Service to VPC Endpoints"

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = module.andahalf.service_sg_id
}
