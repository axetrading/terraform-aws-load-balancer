output "listener_arn" {
  value = aws_lb_listener.this.arn
}

output "listener_port" {
  value = aws_lb_listener.this.port
}

output "listener_protocol" {
  value = aws_lb_listener.this.protocol
}

output "listener_ssl_policy" {
  value = aws_lb_listener.this.ssl_policy
}