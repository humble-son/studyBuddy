resource "aws_ecr_repository" "ecr_repo" {
  name                 = lower(var.project_name)
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "studybuddy_ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "studybuddy" {
  name              = "studybuddy"
  retention_in_days = 30
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "studybuddy" {
  family                   = "studyBuddy"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 1024
  memory = 2048

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = data.aws_region.current.region
          awslogs-group         = aws_cloudwatch_log_group.studybuddy.name
          awslogs-stream-prefix = "nextjs"
        }
      }
    }
  ])
}

resource "aws_ecs_cluster" "main" {
  name = "studyBuddy"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_security_group" "ecs" {
  name        = var.ecs_security_group
  description = "Allow traffic only on port 3000 from the load balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.ecs_security_group
  }
}

resource "aws_security_group" "ecs_lb" {
  name        = var.alb_security_group
  description = "Allow inbound traffic to the ALB from the internet"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.alb_security_group
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.ecs_lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  security_group_id = aws_security_group.ecs_lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_3000" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.ecs_lb.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
}

resource "aws_vpc_security_group_egress_rule" "ecs_all_ipv4" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_ipv4" {
  security_group_id = aws_security_group.ecs_lb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_lb_target_group" "target_group" {
  name        = var.alb_target_group
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb" "lb" {
  name               = "studybuddy-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.ecs_lb.id]
  subnets         = var.public_subnet_ids
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.certificate_arn != "" ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.certificate_arn != "" ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    target_group_arn = var.certificate_arn == "" ? aws_lb_target_group.target_group.arn : null
  }
}

resource "aws_lb_listener" "listener_https" {
  count             = var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_ecs_service" "nextjs" {
  name            = "studyBuddy_frontend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.studybuddy.arn

  desired_count = 2
  launch_type   = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener_http]
}

resource "aws_iam_role" "github_actions" {
  name = "studybuddy_github_actions_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:humble-son/studyBuddy:environment:production"
          }
        }
      }
    ]
  })

  tags = {
    Environment = "production"
    Project     = "studyBuddy"
  }
}

resource "aws_iam_policy" "github_ecr_push" {
  name        = "studybuddy_github_actions_ecr_push"
  description = "Allow GitHub Actions to push images to the studyBuddy ECR repository."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = aws_ecr_repository.ecr_repo.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_ecr_push" {
  policy_arn = aws_iam_policy.github_ecr_push.arn
  role       = aws_iam_role.github_actions.name
}

resource "aws_iam_policy" "github_ecs_deploy" {
  name        = "studybuddy_github_actions_ecs_deploy"
  description = "Allow GitHub Actions to deploy the studyBuddy application to ECS."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = ["ecs:DescribeTaskDefinition"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ecs:RegisterTaskDefinition"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["ecs:UpdateService", "ecs:DescribeServices"]
        Resource = aws_ecs_service.nextjs.arn
      },
      {
        Effect = "Allow"
        Action = ["iam:PassRole"]
        Resource = aws_iam_role.ecs_task_execution.arn
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = "production"
  }
}

resource "aws_iam_role_policy_attachment" "github_ecs_deploy" {
  policy_arn = aws_iam_policy.github_ecs_deploy.arn
  role       = aws_iam_role.github_actions.name
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Environment = "production"
    Project     = "studyBuddy"
  }
}
