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