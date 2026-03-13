variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "local_name" {
  description = "Infra stack/cluster name and Environent for resources local name"
  type        = map(string)
  default = {
    name = "hakaton-app",
    env  = "dev"
  }
}

variable "vpc_cidr_block" {
  description = "Main VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_subnets_count" {
  description = "no. of subnets to launch"
  type        = number
  default     = 2 # For EKS, you need at least two availability zones??
}


variable "project_name" {
  description = "Project prefix"
  type        = string
  default     = "cognito-api-auth"
}

variable "enable_user_pool_domain" {
  description = "Create a Cognito domain for hosted UI (optional)"
  type        = bool
  default     = false
}

variable "user_pool_domain_prefix" {
  description = "Cognito domain prefix (if enable_user_pool_domain = true)"
  type        = string
  default     = "my-auth-domain"
}

#ELB uri
variable "services" {
  type    = map(string)
  default = {}
}