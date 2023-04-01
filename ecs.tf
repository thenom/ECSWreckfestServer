locals {
  distinct_ports_list = distinct(concat(tolist(var.tcp_ports), tolist(var.udp_ports), tolist(var.tcp_udp_ports)))
  port_mappings       = [for port in local.distinct_ports_list : "{ \"containerPort\": ${port} }"]
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "Wreckfest"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  execution_role_arn = aws_iam_role.task.arn

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "server",
    "image": "${aws_ecr_repository.repo.repository_url}:latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "environment": [
      {
        "name": "SERVER_NAME", "value": "${var.server_name}"
      },
      {
        "name": "WELCOME_MESSAGE", "value": "${var.welcome_message}"
      },
      {
        "name": "GAME_PASSWORD", "value": "${var.server_password}"
      },
      {
        "name": "ADMIN_STEAM_IDS", "value": "${join(",", var.admin_steam_ids)}"
      }
    ],
    "portMappings": [
${join(", ", local.port_mappings)}
    ]
  }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "service" {
  name            = "Wreckfest"
  cluster         = "fargate"
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = 1
  depends_on      = [aws_iam_role.task]

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.container.id]
  }

  dynamic "load_balancer" {
    for_each = var.tcp_ports
    content {
      target_group_arn = aws_lb_target_group.tcp_container[load_balancer.key].arn
      container_name   = "server"
      container_port   = load_balancer.key
    }
  }

  dynamic "load_balancer" {
    for_each = var.udp_ports
    content {
      target_group_arn = aws_lb_target_group.udp_container[load_balancer.key].arn
      container_name   = "server"
      container_port   = load_balancer.key
    }
  }

  dynamic "load_balancer" {
    for_each = var.tcp_udp_ports
    content {
      target_group_arn = aws_lb_target_group.tcp_udp_container[load_balancer.key].arn
      container_name   = "server"
      container_port   = load_balancer.key
    }
  }
}
