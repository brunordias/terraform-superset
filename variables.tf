variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS Region."
}

variable "name" {
  type        = string
  description = "Used to name resources and prefixes."
}

variable "vpc_name" {
  type        = string
  description = "Nome da VPC"
}

variable "private_subnets" {
  type        = list(any)
  description = "Lista dos nomes das subnets privadas"
}

variable "public_subnets" {
  type        = list(any)
  description = "Lista dos nomes das subnets publicas"
}

variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "Assign a public IP address to the ENI"
}

variable "app_environment" {
  type        = list(any)
  default     = []
  description = "List of one or more environment variables to be inserted in the container."
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(any)
  default     = {}
}

variable "app_port" {
  type        = number
  default     = 8088
  description = "The application TCP port number."
}

variable "fargate_cpu" {
  type        = number
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)."
  default     = 1024
}

variable "fargate_memory" {
  type        = number
  description = "Fargate instance memory to provision (in MiB)."
  default     = 2048
}

variable "load_balancer" {
  type        = bool
  default     = true
  description = "Boolean designating a load balancer."
}

variable "ecs_service" {
  type        = bool
  default     = true
  description = "Boolean designating a service."
}

variable "policies" {
  type        = list(any)
  default     = []
  description = "List of one or more IAM policy ARN to be used in the Task execution IAM role."
}

variable "log_retention_in_days" {
  type        = number
  default     = 7
  description = "The number of days to retain log in CloudWatch."
}

variable "cloudwatch_log_group_name" {
  type        = string
  default     = ""
  description = "The name of an existing CloudWatch group."
}

variable "health_check" {
  type = map(any)
  default = {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 10
  }
  description = "Health check in Load Balance target group."
}

variable "service_discovery_namespace_id" {
  type        = string
  default     = null
  description = "Service Discovery Namespace ID."
}

variable "ecs_service_desired_count" {
  type        = number
  default     = 1
  description = "The number of instances of the task definition to place and keep running."
}

variable "fargate_essential" {
  type        = bool
  default     = true
  description = "Boolean designating a Fargate essential container."
}

variable "lb_target_group_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol to use for routing traffic to the targets. Should be one of TCP, TLS, UDP, TCP_UDP, HTTP or HTTPS."
}

variable "lb_target_group_port" {
  type        = number
  default     = 80
  description = "The port on which targets receive traffic, unless overridden when registering a specific target."
}

variable "lb_target_group_type" {
  type        = string
  default     = "ip"
  description = "The type of target that you must specify when registering targets with this target group."
}

variable "lb_listener_arn" {
  type        = list(any)
  default     = [""]
  description = "List of ARN LB listeners"
}

variable "hosted_zone" {
  type        = string
  description = "Route 53 hosted zone name for this app."
}

variable "lb_host_header" {
  type        = list(any)
  default     = null
  description = "List of host header patterns to match."
}

variable "lb_path_pattern" {
  type        = list(any)
  default     = null
  description = "List of path patterns to match."
}

variable "capacity_provider_strategy" {
  type = map(any)
  default = {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
    base              = null
  }
  description = "The capacity provider strategy to use for the service."
}

variable "lb_priority" {
  type        = number
  default     = null
  description = "The priority for the rule between 1 and 50000."
}

variable "autoscaling" {
  type        = bool
  default     = false
  description = "Boolean designating an Auto Scaling."
}

variable "autoscaling_settings" {
  type = map(any)
  default = {
    max_capacity       = 5
    min_capacity       = 1
    target_cpu_value   = 65
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
  description = "Settings of Auto Scaling."
}

variable "platform_version" {
  type        = string
  default     = "1.4.0"
  description = "The Fargate platform version on which to run your service."
}

variable "efs_volume_configuration" {
  type        = list(any)
  default     = []
  description = "Settings of EFS volume configuration."
}

variable "efs_mount_configuration" {
  type        = list(any)
  default     = []
  description = "Settings of EFS mount configuration."
}

variable "deployment_circuit_breaker" {
  type        = string
  default     = true
  description = "Boolean designating a deployment circuit breaker."
}

variable "db_password" {
  type        = string
  description = "DB Password."
}
