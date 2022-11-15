variable "listener_arn" {
  type        = string
  description = "AWS Load Balancer listener arn identifier"

}
variable "listener_rules" {
  type        = list(any)
  description = "A list of http listener rules configurations"
  default     = []
}


variable "eks_cluster_name" {
  type    = string
  default = null

}

variable "target_group_arn" {
  type = string
  description = "AWS Load Balancer Target Group ARN"
  default = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags"
  default     = {}
}