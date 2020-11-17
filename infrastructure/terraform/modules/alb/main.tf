resource "aws_security_group" "this" {
  name        = "${var.project_name}_${var.env}_http_https"
  description = "Allow TCP inbound traffic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "alb_80_in" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.http_allow_cidrs
}

resource "aws_security_group_rule" "alb_443_in" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.https_allow_cidrs
}

resource "aws_security_group_rule" "alb_all_out" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_lb_target_group" "http" {
  // TGs can have only hypens in name
  name     = "${replace(var.project_name, "_", "-")}-${var.env}-http"
  port     = var.traefik_http_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled  = true
    path     = var.traefik_healthcheck_path
    port     = var.traefik_healthcheck_port
    protocol = var.traefik_healthcheck_protocol
    interval = var.interval
  }
}

resource "aws_lb_target_group" "https" {
  // TGs can have only hypens in name
  name     = "${replace(var.project_name, "_", "-")}-${var.env}-https"
  port     = var.traefik_https_port
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    enabled  = true
    path     = var.traefik_healthcheck_path
    port     = var.traefik_healthcheck_port
    protocol = var.traefik_healthcheck_protocol
    interval = var.interval
  }
}

resource "aws_lb" "alb" {
  // LBs can have only hypens in name
  name               = "${replace(var.project_name, "_", "-")}-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.this.id,
  ]
  subnets                    = var.subnets
  enable_deletion_protection = false
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_https_port
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https.arn
  }

  ssl_policy      = var.ssl_policy
  certificate_arn = var.certificate_arn
}

resource "aws_lb_listener_certificate" "https" {
  count           = length(var.additional_certificates_arns)
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.additional_certificates_arns[count.index]
}