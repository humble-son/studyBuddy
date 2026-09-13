variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN used by the ALB HTTPS listener. Leave empty to keep HTTP-only access."
  type        = string
  default     = ""
}