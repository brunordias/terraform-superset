module "redis" {
  source  = "cloudposse/elasticache-redis/aws"
  version = "0.40.0"

  name                       = var.name
  vpc_id                     = data.aws_vpc.this.id
  subnets                    = data.aws_subnet_ids.private.ids
  cluster_size               = 1
  instance_type              = "cache.t3.micro"
  apply_immediately          = true
  automatic_failover_enabled = false
  engine_version             = "6.x"
  family                     = "redis6.x"
  at_rest_encryption_enabled = false
  transit_encryption_enabled = false

  security_group_rules = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      description              = "Allow all outbound traffic"
    },
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = [data.aws_vpc.this.cidr_block]
      source_security_group_id = null
      description              = "Allow all inbound traffic from trusted Security Groups"
    },
  ]
}
