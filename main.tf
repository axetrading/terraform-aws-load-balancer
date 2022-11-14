#locals {
#  lb_listeners = flatten([
#    for name, value in var.lb_listeners : {
#      listener_port     = value.listener_port
#      listener_protocol = value.protocol
#      ssl_policy        = value.ssl_policy
#      certificate_arn   = value.certificate_arn
#    } if var.lb_listeners != {} 
#  ]) 
#}

resource "aws_lb" "main" {
  count                      = var.create_load_balancer ? 1 : 0
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

module "target_group" {
  source = "./modules/target-groups"
  
  for_each = { for k, v in var.target_groups : k => v if var.target_groups != {} && var.target_groups != null }
  name = try(each.value.name, null)
  port = try(each.value.port, "80", null)
  protocol = lookup(each.value, "tg_protocol", var.load_balancer_type == "application" ? "HTTPS" : "TLS")
  vpc_id = lookup(each.value, "vpc_id", var.vpc_id)
  target_type = lookup(each.value, "target_type", "ip")
  deregistration_delay = lookup(each.value, "deregistration_delay", "300")
}
