resource "aws_lb_listener" "this" {
  for_each          = { for k, v in var.lb_listeners : k => v if var.lb_listeners != {} && var.lb_listeners != null }
  load_balancer_arn = var.create_load_balancer ? aws_lb.main[0].arn : var.load_balancer_arn
  port              = lookup(each.value, "listener_port", 443)
  protocol          = lookup(each.value, "listener_protocol", var.load_balancer_type == "application" ? "HTTPS" : "TLS")
  ssl_policy        = contains(["HTTPS", "TLS"], lookup(each.value, "listener_protocol", var.load_balancer_type == "application" ? "HTTPS" : "TLS")) ? lookup(each.value, "ssl_policy", "ELBSecurityPolicy-2016-08") : null
  certificate_arn   = contains(["HTTPS", "TLS"], lookup(each.value, "listener_protocol", var.load_balancer_type == "application" ? "HTTPS" : "TLS")) ? lookup(each.value, "certificate_arn", try(var.certificate_arn, null)) : null

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "NOT FOUND"
      status_code  = "404"
    }
  }
}