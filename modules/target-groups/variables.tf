variable "name" {
  type        = string
  description = "Name of the target group"
}
variable "port" {
  type        = string
  description = "Port to use to connect with the target"
  default     = "80"
}

variable "protocol" {
  type        = string
  description = "Protocol to use to connect with the target"
  default     = "HTTP"
}

variable "protocol_version" {
  type        = string
  description = "Only applicable when protocol is HTTP or HTTPS"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "Identifier of the VPC in which to create the target group"
  default     = null
}

variable "target_type" {
  type        = string
  description = "Type of target that you must specify when registering targets with this target group"
  default     = "ip"
}

variable "deregistration_delay" {
  type        = string
  default     = "300"
  description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused"
}

### Health Check Variables
variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request"
}

variable "health_check_port" {
  type        = string
  default     = "traffic-port"
  description = "The port to use for the healthcheck"
}

variable "health_check_protocol" {
  type        = string
  default     = null
  description = "The protocol to use for the healthcheck. If not specified, same as the traffic protocol"
}

variable "health_check_timeout" {
  type        = number
  default     = 10
  description = "The amount of time to wait in seconds before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "health_check_interval" {
  type        = number
  default     = 15
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  default     = "200-399"
  description = "The HTTP response codes to indicate a healthy check"
}


### Stickiness Variables 

variable "stickiness_type" {
  type        = string
  description = "The type of sticky sessions. The only current possible values are lb_cookie, app_cookie for ALBs, source_ip for NLBs, and source_ip_dest_ip, source_ip_dest_ip_proto for GWLBs"
  default     = "lb_cookie"
}

variable "stickiness_cookie_duration" {
  type        = string
  description = "The time period, in seconds, during which requests from a client should be routed to the same target"
  default     = "86400"
}

variable "stickiness_enabled" {
  type        = bool
  description = "Boolean to enable / disable stickiness"
  default     = false
}