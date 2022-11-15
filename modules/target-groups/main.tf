resource "aws_lb_target_group" "this" {
  name                 = var.name
  port                 = var.port
  protocol             = var.protocol
  protocol_version =   var.protocol_version
  vpc_id               = var.vpc_id
  target_type          = var.target_type
  deregistration_delay = var.deregistration_delay
  health_check {
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    interval            = var.health_check_interval
    path                = var.health_check_path
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
    enabled         = var.stickiness_enabled
  }
}
