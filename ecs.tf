## ECS Cluster
module "ecs_cluster" {
  source  = "brunordias/ecs-cluster/aws"
  version = "~> 1.0.0"

  name               = var.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = {
    capacity_provider = "FARGATE"
    weight            = null
    base              = null
  }
  container_insights = "disabled"

  tags = var.tags
}

## ECS Fargate
module "ecs_fargate" {
  source  = "brunordias/ecs-fargate/aws"
  version = "4.1.0"

  name                           = var.name
  region                         = var.region
  ecs_cluster                    = module.ecs_cluster.id
  image_uri                      = "brunodias/superset:2.0.0"
  platform_version               = var.platform_version
  vpc_name                       = var.vpc_name
  subnet_name                    = var.private_subnets
  assign_public_ip               = var.assign_public_ip
  fargate_cpu                    = var.fargate_cpu
  fargate_memory                 = var.fargate_memory
  ecs_service_desired_count      = var.ecs_service_desired_count
  app_port                       = var.app_port
  load_balancer                  = var.load_balancer
  ecs_service                    = var.ecs_service
  service_discovery_namespace_id = var.service_discovery_namespace_id
  policies                       = var.policies
  lb_listener_arn                = [aws_lb_listener.https.arn]
  lb_path_pattern                = var.lb_path_pattern
  lb_host_header                 = ["${var.name}.${var.hosted_zone}"]
  lb_priority                    = var.lb_priority
  health_check                   = var.health_check
  capacity_provider_strategy     = var.capacity_provider_strategy
  autoscaling                    = var.autoscaling
  autoscaling_settings           = var.autoscaling_settings
  efs_volume_configuration       = var.efs_volume_configuration
  efs_mount_configuration        = var.efs_mount_configuration
  deployment_circuit_breaker     = var.deployment_circuit_breaker
  app_environment = [
    {
      "name"  = "COMPOSE_PROJECT_NAME",
      "value" = "superset"
    },
    {
      "name"  = "PYTHONPATH",
      "value" = "/app/pythonpath:/app/docker/pythonpath_dev"
    },
    {
      "name"  = "FLASK_ENV",
      "value" = "production"
    },
    {
      "name"  = "SUPERSET_ENV",
      "value" = "production"
    },
    {
      "name"  = "SUPERSET_LOAD_EXAMPLES",
      "value" = "yes"
    },
    {
      "name"  = "CYPRESS_CONFIG",
      "value" = false
    },
    {
      "name"  = "SUPERSET_PORT",
      "value" = 8088
    },
    {
      "name"  = "DATABASE_HOST",
      "value" = module.rds.this_rds_cluster_endpoint
    },
    {
      "name"  = "DATABASE_USER",
      "value" = local.db_user
    },
    {
      "name"  = "DATABASE_PASSWORD",
      "value" = var.db_password
    },
    {
      "name"  = "DATABASE_DB",
      "value" = local.db_database
    },
    {
      "name"  = "DATABASE_PORT",
      "value" = 3306
    },
    {
      "name"  = "DATABASE_DIALECT",
      "value" = "mysql"
    },
    {
      "name"  = "MYSQL_USER",
      "value" = local.db_user
    },
    {
      "name"  = "MYSQL_PASSWORD",
      "value" = var.db_password
    },
    {
      "name"  = "MYSQL_DATABASE",
      "value" = local.db_database
    },
    {
      "name"  = "REDIS_HOST",
      "value" = module.redis.endpoint
    },
    {
      "name"  = "REDIS_PORT",
      "value" = 6379
    }
  ]

  tags = var.tags
}

## Route 53
resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.name}.${var.hosted_zone}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
