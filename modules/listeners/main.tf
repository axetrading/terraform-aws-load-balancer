resource "aws_lb_listener" "this" {

  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = (var.listener_protocol == "HTTPS" || var.listener_protocol == "TLS") && var.load_balancer_type == "application" ? try(var.listener_ssl_policy, "ELBSecurityPolicy-2016-08") : null
  certificate_arn   = (var.listener_protocol == "HTTPS" || var.listener_protocol == "TLS") && var.load_balancer_type == "application" ? try(var.listener_certificate_arn, null) : null

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "NOT FOUND"
      status_code  = "404"
    }
  }
}