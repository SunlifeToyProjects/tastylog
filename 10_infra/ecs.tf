# ---------------------------------------------
# Elastic Container Service - Cluster
# ---------------------------------------------
resource "aws_ecs_cluster" "webapp" {
  name = "${var.project}-${var.environment}-webapp-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name    = "${var.project}-${var.environment}-webapp-cluster"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# Elastic Container Service - Service
# ---------------------------------------------
resource "aws_ecs_service" "webapp" {
  name = "${var.project}-${var.environment}-webapp-service"

  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.webapp.id
  task_definition = aws_ecs_task_definition.webapp.arn
  desired_count   = 1
  # depends_on      = [aws_iam_role.ecs_task_exec_iam_role]

  network_configuration {
    subnets = [aws_subnet.public_subnet_1a.id]
    security_groups = [
      aws_security_group.app_sg.id,
      aws_security_group.opmng_sg.id,
    ]
    assign_public_ip = true
  }

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.webapp_blue.arn
    container_name   = "webapp"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition, load_balancer]
  }
}

# ---------------------------------------------
# Elastic Container Service - Task
# ---------------------------------------------
resource "aws_ecs_task_definition" "webapp" {
  family = "${var.project}-${var.environment}-webapp-template"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 # .25 vCPU
  memory                   = 512 # 512 MB

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  execution_role_arn = aws_iam_role.ecs_task_exec_iam_role.arn

  container_definitions = jsonencode([
    {
      name      = "webapp"
      image     = "${aws_ecr_repository.webapp.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      secrets = [
        {
          name      = "MYSQL_HOST"
          valueFrom = "${aws_ssm_parameter.host.arn}"
        },
        {
          name      = "MYSQL_PORT"
          valueFrom = "${aws_ssm_parameter.port.arn}"
        },
        {
          name      = "MYSQL_DATABASE"
          valueFrom = "${aws_ssm_parameter.database.arn}"
        },
        {
          name      = "MYSQL_USERNAME"
          valueFrom = "${aws_ssm_parameter.username.arn}"
        },
        {
          name      = "MYSQL_PASSWORD"
          valueFrom = "${aws_ssm_parameter.password.arn}"
        }
      ]
    }
  ])


  # volume {
  #   name      = "service-storage"
  #   host_path = "/ecs/service-storage"
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }

  tags = {
    Name    = "${var.project}-${var.environment}-webapp-template"
    Project = var.project
    Env     = var.environment
  }
}
