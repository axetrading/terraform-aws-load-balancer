

output "id" {
  description = "The ID and ARN of the load balancer we created."
  value       = try(aws_lb.main[0].id, null)
}

output "arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = try(aws_lb.main[0].arn, null)
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = try(aws_lb.main[0].dns_name, null)
}

output "zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = try(aws_lb.main[0].zone_id, null)
}
# Security Group Outputs

output "security_group_id" {
  value = try(aws_security_group.this[0].id, null)
}

output "security_group_name" {
  value = try(aws_security_group.this[0].name, null)
}

output "security_group_arn" {
  value = try(aws_security_group.this[0].arn, null)
}

# Listeners outputs

output "http_listener_arn" {
  value = try(aws_lb_listener.http[0].arn, null)
}

output "https_listener_arn" {
  value = try(aws_lb_listener.https[0].arn, null)
}

output "tcp_udp_listeners" {
  value = try(aws_lb_listener.this[*].arn, null)
}

output "target_group_names" {
  value = try(aws_lb_target_group.this[*].name, null)
}
output "target_groups" {
  value = { for k, v in aws_lb_target_group.this : v.name => {
    arn               = v.arn
    port              = v.port
    health_check_path = v.health_check[0].path
    health_check_port = v.health_check[0].port
    }
  }
}
