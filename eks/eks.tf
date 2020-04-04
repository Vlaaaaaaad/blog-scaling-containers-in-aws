module "eks" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-eks.git?ref=v10.0.0"

  cluster_version = "1.14"
  cluster_name    = local.cluster_name

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  worker_additional_security_group_ids = [
    aws_security_group.vpc_endpoints_in_n_out.id
  ]

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  cluster_log_retention_in_days = "365"
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  manage_aws_auth  = true
  write_kubeconfig = false

  map_roles = [
    {
      rolearn  = "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/AWSReservedSSO_xxxxxxxxxxx/vlad.ionescu"
      username = "vlad.ionescu"
      groups   = ["system:masters"]
    },
  ]

  worker_groups_launch_template = [
    {
      name = "ondemand"
      override_instance_types                  = ["c5.4xlarge"]
      # override_instance_types                  = ["t3.medium"]
      on_demand_percentage_above_base_capacity = 100

      asg_min_size          = 1
      asg_max_size          = 10
      asg_force_delete      = true
      protect_from_scale_in = true

      root_encrypted   = true
      root_volume_size = "100"
      root_volume_type = "gp2"

      enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

      kubelet_extra_args = " --node-labels=nodegroup=ondemand "

      subnets = module.vpc.private_subnets
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage"
          "propagate_at_launch" = "false"
          "value"               = "100Gi"
        },
      ]
    },
    {
      name                                     = "spot-new"
      # override_instance_types                  = ["t3.medium"]
      override_instance_types                  = ["m5.4xlarge", "c5.4xlarge", "c5n.4xlarge", "r5.4xlarge"]
      on_demand_percentage_above_base_capacity = 0

      asg_min_size          = 1
      asg_max_size          = 1000
      asg_force_delete      = true
      protect_from_scale_in = true

      root_encrypted   = true
      root_volume_size = "100"
      root_volume_type = "gp2"

      enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

      kubelet_extra_args = " --node-labels=kubernetes.io/lifecycle=spot,nodegroup=spot --cluster-dns=169.254.20.10 "

      subnets = module.vpc.private_subnets
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage"
          "propagate_at_launch" = "false"
          "value"               = "100Gi"
        },
      ]
    },
    {
      name                                     = "ondemand"
      # override_instance_types                  = ["t3.medium"]
      override_instance_types                  = ["m4.4xlarge", "c4.4xlarge", "r4.4xlarge"]
      on_demand_percentage_above_base_capacity = 0

      asg_min_size          = 1
      asg_max_size          = 1000
      asg_force_delete      = true
      protect_from_scale_in = true

      root_encrypted   = true
      root_volume_size = "100"
      root_volume_type = "gp2"

      enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

      kubelet_extra_args = " --node-labels=kubernetes.io/lifecycle=spot,nodegroup=spot --cluster-dns=169.254.20.10 "

      subnets = module.vpc.private_subnets
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage"
          "propagate_at_launch" = "false"
          "value"               = "100Gi"
        },
      ]
    },
  ]

  tags = local.common_tags
}
