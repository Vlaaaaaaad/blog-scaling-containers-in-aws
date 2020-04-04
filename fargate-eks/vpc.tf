module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.24.0"
  name    = local.cluster_name

  azs = data.aws_availability_zones.available.names

  cidr = "172.16.0.0/16"
  public_subnets = [
    "172.16.0.0/19",
    "172.16.32.0/19",
    "172.16.64.0/19",
    "172.16.96.0/19",
    "172.16.128.0/19",
    "172.16.160.0/19",
  ]

  secondary_cidr_blocks = [
    "172.17.0.0/16",
    "172.18.0.0/16",
    "172.19.0.0/16",
  ]
  private_subnets = [
    "172.17.0.0/16",
    "172.18.0.0/16",
    "172.19.0.0/16",
  ]

  enable_dns_support   = true
  enable_dns_hostnames = true

  # One NAT Gateway per AZ
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  single_nat_gateway     = false

  # S3 VPC Endpoint
  enable_s3_endpoint = true

  # EC2 VPC Enpoints
  enable_ec2_endpoint              = true
  ec2_endpoint_private_dns_enabled = true
  ec2_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  enable_ec2messages_endpoint              = true
  ec2messages_endpoint_private_dns_enabled = true
  ec2messages_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # ECR VPC Endpoints
  enable_ecr_api_endpoint              = true
  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  enable_ecr_dkr_endpoint              = true
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # ECS VPC Endpoints( needed for ECR and EKS)
  enable_ecs_endpoint              = true
  ecs_endpoint_private_dns_enabled = true
  ecs_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  enable_ecs_telemetry_endpoint              = true
  ecs_telemetry_endpoint_private_dns_enabled = true
  ecs_telemetry_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  enable_ecs_agent_endpoint              = true
  ecs_agent_endpoint_private_dns_enabled = true
  ecs_agent_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # CloudWatch Endpoints
  enable_monitoring_endpoint              = true
  monitoring_endpoint_private_dns_enabled = true
  monitoring_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  enable_logs_endpoint              = true
  logs_endpoint_private_dns_enabled = true
  logs_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  enable_events_endpoint              = true
  events_endpoint_private_dns_enabled = true
  events_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # ALB/ ELB Endpoint
  enable_elasticloadbalancing_endpoint              = true
  elasticloadbalancing_endpoint_private_dns_enabled = true
  elasticloadbalancing_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # KMS Endpoint
  enable_kms_endpoint              = true
  kms_endpoint_private_dns_enabled = true
  kms_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # CloudTrail Endpoint
  enable_cloudtrail_endpoint              = true
  cloudtrail_endpoint_private_dns_enabled = true
  cloudtrail_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # STS Endpoint
  enable_sts_endpoint              = true
  sts_endpoint_private_dns_enabled = true
  sts_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  # SecretsManager Endpoint
  enable_secretsmanager_endpoint              = true
  secretsmanager_endpoint_private_dns_enabled = true
  secretsmanager_endpoint_security_group_ids  = [aws_security_group.vpc_endpoints_in_n_out.id]

  private_subnet_tags = merge(
    local.common_tags,
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    },
    {
      "kubernetes.io/role/internal-elb" = "1"
    },
  )

  public_subnet_tags = merge(
    local.common_tags,
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    },
    {
      "kubernetes.io/role/elb" = "1"
    },
  )

  vpc_tags = local.common_tags

  tags = merge(
    local.common_tags,
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    },
  )
}
