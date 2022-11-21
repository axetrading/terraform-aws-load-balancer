

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
  value = aws_security_group.this[0].id
}

output "security_group_name" {
  value = aws_security_group.this[0].name
}

output "security_group_arn" {
  value = aws_security_group.this[0].arn
}

# Listeners outputs

output "http_listener_arn" {
  value = aws_lb_listener.http[0].arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https[0].arn
}

output "target_group_names" {
  value = aws_lb_target_group.this[*].name
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
