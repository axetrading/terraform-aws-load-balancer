

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

output "listener_arn" {
  value = { for k, v in aws_lb_listener.this : k => v.arn }
}