output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "target_group_id" {
  value = aws_lb_target_group.this.id
}

output "target_group_name" {
  value = aws_lb_target_group.this.name
}

output "target_group_health_check" {
  value = aws_lb_target_group.this.health_check
}