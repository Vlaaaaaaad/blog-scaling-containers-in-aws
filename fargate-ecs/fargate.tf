resource "aws_ecs_cluster" "cluster" {
  name = local.cluster_name

  capacity_providers = [
    "FARGATE_SPOT",
  ]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 3500
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}

module "one" {
  source  = "telia-oss/ecs-fargate/aws"
  version = "3.3.0"

  cluster_id         = aws_ecs_cluster.cluster.id
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  name_prefix          = "one"
  task_container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/test-repo:latest"
  desired_count        = 1
  # desired_count                      = 1000
  deployment_maximum_percent         = 600
  deployment_minimum_healthy_percent = 20

  task_definition_cpu    = 1024
  task_definition_memory = 2048
  task_container_port    = 5003

  health_check = {
    port = "traffic-port"
    path = "/status/alive"
  }

  tags = local.common_tags
}


module "two" {
  source  = "telia-oss/ecs-fargate/aws"
  version = "3.3.0"

  cluster_id         = aws_ecs_cluster.cluster.id
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  name_prefix          = "two"
  task_container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/test-repo:latest"
  desired_count        = 1
  # desired_count                      = 1000
  deployment_maximum_percent         = 600
  deployment_minimum_healthy_percent = 20

  task_definition_cpu    = 1024
  task_definition_memory = 2048
  task_container_port    = 5003

  health_check = {
    port = "traffic-port"
    path = "/status/alive"
  }

  tags = local.common_tags
}

module "three" {
  source  = "telia-oss/ecs-fargate/aws"
  version = "3.3.0"

  cluster_id         = aws_ecs_cluster.cluster.id
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  name_prefix          = "three"
  task_container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/test-repo:latest"
  desired_count        = 1
  # desired_count                      = 1000
  deployment_maximum_percent         = 600
  deployment_minimum_healthy_percent = 20

  task_definition_cpu    = 1024
  task_definition_memory = 2048
  task_container_port    = 5003

  health_check = {
    port = "traffic-port"
    path = "/status/alive"
  }

  tags = local.common_tags
}

module "andahalf" {
  source  = "telia-oss/ecs-fargate/aws"
  version = "3.3.0"

  cluster_id         = aws_ecs_cluster.cluster.id
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  name_prefix          = "andahalf"
  task_container_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/test-repo:latest"
  desired_count        = 1
  # desired_count                      = 500
  deployment_maximum_percent         = 600
  deployment_minimum_healthy_percent = 20

  task_definition_cpu    = 1024
  task_definition_memory = 2048
  task_container_port    = 5003

  health_check = {
    port = "traffic-port"
    path = "/status/alive"
  }

  tags = local.common_tags
}
