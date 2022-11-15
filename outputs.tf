# load balancer outputs

# load balancer listener outputs 

output "listener_arns" {
  value = join("", aws_lb_listener.this.*.arn)
}