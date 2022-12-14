resource "aws_lb" "main" {
  count = var.create_load_balancer ? 1 : 0

  desync_mitigation_mode     = var.desync_mitigation_mode
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  enable_waf_fail_open       = var.enable_waf_fail_open
  idle_timeout               = var.idle_timeout
  internal                   = var.internal
  ip_address_type            = var.ip_address_type
  load_balancer_type         = var.load_balancer_type
  name                       = var.name
  security_groups            = local.create_security_group ? concat([aws_security_group.this[0].id], var.security_groups) : var.security_groups


  subnets = var.subnets

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  count             = var.http_listener_enabled ? 1 : 0
  load_balancer_arn = var.create_load_balancer ? aws_lb.main[0].arn : var.load_balancer_arn
  port              = var.http_listener_port
  protocol          = var.http_listener_protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "NOT FOUND"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "http_redirect" {
  count = var.http_listener_enabled ? 1 : 0

  listener_arn = aws_lb_listener.http[0].arn

  action {
    type = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener" "https" {
  count             = var.https_listener_enabled ? 1 : 0
  load_balancer_arn = var.create_load_balancer ? aws_lb.main[0].arn : var.load_balancer_arn
  port              = var.https_listener_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "NOT FOUND"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "this" {
  count                = length(var.target_groups)
  name                 = lookup(var.target_groups[count.index], "tg_name", null)
  port                 = lookup(var.target_groups[count.index], "tg_port", 80)
  protocol             = lookup(var.target_groups[count.index], "tg_protocol", var.load_balancer_type == "application" ? "HTTPS" : "TLS")
  protocol_version     = lookup(var.target_groups[count.index], "tg_protocol_version", var.load_balancer_type == "application" ? "HTTP2" : null)
  vpc_id               = var.vpc_id
  target_type          = lookup(var.target_groups[count.index], "target_type", "ip")
  deregistration_delay = lookup(var.target_groups[count.index], "deregistration_delay", 300)

  health_check {
    port                = lookup(var.target_groups[count.index], "health_check_port", 80)
    protocol            = lookup(var.target_groups[count.index], "health_check_protocol", "HTTP")
    interval            = lookup(var.target_groups[count.index], "health_check_interval", 30)
    path                = lookup(var.target_groups[count.index], "health_check_protocol", "HTTP") == "HTTP" || lookup(var.target_groups[count.index], "health_check_protocol", "HTTP") == "HTTPS" ? lookup(var.target_groups[count.index], "health_check_path", "/actuator/health") : null
    timeout             = lookup(var.target_groups[count.index], "health_check_timeout", var.load_balancer_type == "application" ? 5 : null)
    healthy_threshold   = lookup(var.target_groups[count.index], "health_check_healthy_threshold", 2)
    unhealthy_threshold = lookup(var.target_groups[count.index], "health_check_unhealthy_threshold", 2)
    matcher             = lookup(var.target_groups[count.index], "health_check_matcher", var.load_balancer_type == "application" ? 200 : null)
  }
  stickiness {
    type            = lookup(var.target_groups[count.index], "stickiness_type", var.load_balancer_type == "application" ? "lb_cookie" : "source_ip")
    cookie_duration = lookup(var.target_groups[count.index], "stickiness_cookie_duration", var.load_balancer_type == "application" ? 86400 : null)
    enabled         = lookup(var.target_groups[count.index], "enable_stickiness", false)
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb_listener_rule" "this" {
  count = length(var.target_groups)

  listener_arn = aws_lb_listener.https[0].arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[count.index].arn
  }
    dynamic "condition" {
    for_each = [
      for condition_rule in var.target_groups[count.index].listner_conditions :
      condition_rule
      if length(lookup(condition_rule, "path_patterns", [])) > 0
    ]

    content {
      path_pattern {
        values = condition.value["path_patterns"]
      }
    }
  }

  # Host header condition
  dynamic "condition" {
    for_each = [
      for condition_rule in var.target_groups[count.index].listner_conditions :
      condition_rule
      if length(lookup(condition_rule, "host_headers", [])) > 0
    ]

    content {
      host_header {
        values = condition.value["host_headers"] 
      }
    }
  }
  tags = var.tags
}


