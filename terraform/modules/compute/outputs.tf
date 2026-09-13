# --------------------------------------------------
# General
# --------------------------------------------------

output "project_name" {
  description = "Name of the project."

  value = var.project_name
}

# --------------------------------------------------
# ECR
# --------------------------------------------------

output "ecr_repository_name" {
  description = "Name of the ECR repository."

  value = aws_ecr_repository.ecr_repo.name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository."

  value = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository."

  value = aws_ecr_repository.ecr_repo.arn
}

output "ecr_registry_id" {
  description = "AWS account ID of the ECR registry."

  value = aws_ecr_repository.ecr_repo.registry_id
}

# --------------------------------------------------
# ECS Cluster
# --------------------------------------------------

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."

  value = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster."

  value = aws_ecs_cluster.main.arn
}

# --------------------------------------------------
# ECS Task Definition
# --------------------------------------------------

output "ecs_task_definition_family" {
  description = "Family name of the ECS task definition."

  value = aws_ecs_task_definition.studybuddy.family
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition."

  value = aws_ecs_task_definition.studybuddy.arn
}

# --------------------------------------------------
# ECS Service
# --------------------------------------------------

output "ecs_service_name" {
  description = "Name of the ECS service."

  value = aws_ecs_service.nextjs.name
}

output "ecs_service_arn" {
  description = "ARN of the ECS service."

  value = aws_ecs_service.nextjs.arn
}

output "ecs_desired_count" {
  description = "Desired number of ECS tasks."

  value = aws_ecs_service.nextjs.desired_count
}

# --------------------------------------------------
# Application Load Balancer
# --------------------------------------------------

output "alb_name" {
  description = "Name of the Application Load Balancer."

  value = aws_lb.lb.name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."

  value = aws_lb.lb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."

  value = aws_lb.lb.dns_name
}

output "application_url" {
  description = "HTTP URL for the application."

  value = "http://${aws_lb.lb.dns_name}"
}

# --------------------------------------------------
# Target Group
# --------------------------------------------------

output "target_group_arn" {
  description = "ARN of the ECS target group."

  value = aws_lb_target_group.target_group.arn
}

output "target_group_name" {
  description = "Name of the ECS target group."

  value = aws_lb_target_group.target_group.name
}

# --------------------------------------------------
# Security Groups
# --------------------------------------------------

output "ecs_security_group_id" {
  description = "Security group ID used by ECS tasks."

  value = aws_security_group.ecs.id
}

output "alb_security_group_id" {
  description = "Security group ID used by the Application Load Balancer."

  value = aws_security_group.ecs_lb.id
}

# --------------------------------------------------
# CloudWatch
# --------------------------------------------------

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group used by ECS."

  value = aws_cloudwatch_log_group.studybuddy.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group."

  value = aws_cloudwatch_log_group.studybuddy.arn
}

# --------------------------------------------------
# AWS Region
# --------------------------------------------------

output "aws_region" {
  description = "AWS region where the infrastructure is deployed."

  value = data.aws_region.current.region
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}
