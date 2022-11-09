## Locals
locals {
  db_user     = "admin"
  db_database = "superset"
}

## RDS
module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name                  = var.name
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.10.2"
  database_name         = local.db_database
  instance_type         = "db.t3.small"
  subnets               = data.aws_subnet_ids.private.ids
  vpc_id                = data.aws_vpc.this.id
  replica_count         = 1
  apply_immediately     = true
  skip_final_snapshot   = true
  allowed_cidr_blocks   = [data.aws_vpc.this.cidr_block]
  username              = local.db_user
  password              = var.db_password
  publicly_accessible   = false
  create_security_group = true
  copy_tags_to_snapshot = true
  tags                  = var.tags
}