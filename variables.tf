

variable "create_load_balancer" {
  type        = bool
  default     = true
  description = "Set to false to skip the load balancer creation"
}

variable "desync_mitigation_mode" {
  type        = string
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync."
  default     = "defensive"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer."
  default     = false
}

variable "enable_http2" {
  type        = bool
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  default     = true
}

variable "enable_waf_fail_open" {
  type        = bool
  description = "Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF."
  default     = false
}

variable "idle_timeout" {
  type        = number
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application"
  default     = 60
}

variable "internal" {
  type        = bool
  description = "If true, the LB will be internal."
  default     = true
}

variable "ip_address_type" {
  type        = string
  description = "The type of IP addresses used by the subnets for your load balancer."
  default     = "ipv4"
}

variable "load_balancer_type" {
  type        = string
  description = "The type of load balancer to create. Possible values are application, gateway, or network"

}

variable "name" {
  type        = string
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen"
}

variable "preserve_host_header" {
  type        = bool
  description = "ndicates whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change"
  default     = false
}

variable "subnets" {
  type        = list(string)
  description = "A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value for load balancers of type network will force a recreation of the resource"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource"
  default     = {}
}

########### Security Group Variables #########
#### Security Group Variables

variable "create_security_group" {
  description = "Determines whether to create security group for RDS cluster"
  type        = bool
  default     = true
}

variable "security_group_name" {
  type        = string
  description = "RDS Security Group Name"
  default     = ""
}

variable "security_group_description" {
  description = "The description of the security group. If value is set to empty string it will contain cluster name in the description"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = ""
}


variable "security_group_rules" {
  description = "A map of security group  rule definitions to add to the security group created"
  type        = map(any)
  default     = {}
}

variable "security_groups" {
  type        = list(string)
  description = "Additional security groups that should be associated with the Load Balancer: applicable only for Application Load Balancers"
  default     = []
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

## Listeners variables

variable "http_listener_port" {
  type        = string
  description = "HTTP listener port"
  default     = "80"
}

variable "https_listener_port" {
  type        = string
  description = "HTTP listener port"
  default     = "443"
}


variable "http_listener_protocol" {
  type        = string
  description = "HTTP Listener Protocol"
  default     = "HTTP"
}

variable "http_listener_enabled" {
  type        = bool
  description = "Whether to create or not the http, port 80, alb listener"
  default     = true
}

variable "https_listener_enabled" {
  type        = bool
  description = "Whether to create or not the https, port 443, alb listener"
  default     = true
}

variable "tcp_listener_enabled" {
  type        = bool
  description = "Whether to create or not the tcp listeners for the NLB"
  default     = false
}

variable "certificate_arn" {
  type        = string
  description = "AWS ACM Certificate ARN that should be used for the load balancer listner HTTPS or TLS"
  default     = null
}

variable "ssl_policy" {
  type        = string
  description = "Name of the SSL Policy for the listener."
  default     = "ELBSecurityPolicy-2016-08"
}

variable "load_balancer_arn" {
  type        = string
  description = "Existing Load Balancer ARN"
  default     = "value"
}

variable "target_groups" {
  type        = list(any)
  description = "A list of AWS Load Balancer Target Groups"
  default     = []
}