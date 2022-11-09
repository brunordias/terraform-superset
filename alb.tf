## ACM
resource "aws_acm_certificate" "acm" {
  domain_name       = "${var.name}.${var.hosted_zone}"
  validation_method = "DNS"
}

resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "acm" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

## Load Balancer
## SG
resource "aws_security_group" "alb" {
  name   = "${var.name}-alb"
  vpc_id = data.aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

## ALB
resource "aws_lb" "alb" {
  name               = var.name
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.public.ids
  security_groups    = [aws_security_group.alb.id]
  idle_timeout       = 60

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.acm.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Requests otherwise not routed"
      status_code  = "200"
    }
  }
}
