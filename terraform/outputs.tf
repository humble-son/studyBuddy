output "aws_region" {
  description = "AWS region used for the deployment."
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID created for the project."
  value       = module.network_module.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the load balancer."
  value       = module.network_module.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for the ECS tasks."
  value       = module.network_module.private_subnet_ids
}

output "ecr_repository_url" {
  description = "ECR repository URL used to store the frontend container image."
  value       = module.compute_module.ecr_repository_url
}

output "ecr_repository_name" {
  description = "ECR repository name."
  value       = module.compute_module.ecr_repository_name
}

output "ecs_cluster_name" {
  description = "ECS cluster created for the app."
  value       = module.compute_module.ecs_cluster_name
}

output "ecs_service_name" {
  description = "ECS service created for the app."
  value       = module.compute_module.ecs_service_name
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = module.compute_module.alb_dns_name
}

output "application_url" {
  description = "Public URL for the application."
  value       = module.compute_module.application_url
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions."
  value       = module.compute_module.github_actions_role_arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group used by the app container."
  value       = module.compute_module.cloudwatch_log_group_name
}


