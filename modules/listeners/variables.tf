variable "load_balancer_arn" {
  type        = string
  description = "AWS Load Balancer ARN"
}

variable "listener_port" {
  type        = number
  description = "Port on which the load balancer is listening. Not valid for Gateway Load Balancers"
  default     = null
}

variable "listener_protocol" {
  type        = string
  description = "Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are HTTP and HTTPS, with a default of HTTP. For Network Load Balancers, valid values are TCP, TLS, UDP, and TCP_UDP. Not valid to use UDP or TCP_UDP if dual-stack mode is enabled. Not valid for Gateway Load Balancers."
  default     = "HTTP"
}

variable "listener_ssl_policy" {
  type        = string
  default     = null
  description = " Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS"
}

variable "listener_certificate_arn" {
  type        = string
  description = "ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS"
  default     = null
}

variable "load_balancer_type" {
  type        = string
  description = "AWS Load Balancer Type - this variable is used in ssl_policy and certificate_arn conditions"
  default     = "application"
}