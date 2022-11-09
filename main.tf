## Providers AWS
provider "aws" {
  region = var.region
}

### Data
data "aws_vpc" "this" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:Name"
    values = var.public_subnets
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:Name"
    values = var.private_subnets
  }
}

data "aws_route53_zone" "zone" {
  name = var.hosted_zone
}
