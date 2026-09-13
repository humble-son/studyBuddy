variable "project_name" {
  type = string
  default = "studyBuddy"
}

variable "ecs_security_group" {
  type = string
  default = "studybuddy_ecs_sg"
}

variable "alb_security_group" {
  type = string
  default = "studybuddy_alb_sg"
}

variable "alb_target_group" {
  type = string
  default = "studybuddy-target-group"
}

variable "container_name" {
  type = string
  default = "studyBuddy_frontend"
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN for HTTPS. If empty, the app stays on HTTP only."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of the VPC where ECS resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}
