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