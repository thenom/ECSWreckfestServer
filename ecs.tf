resource "aws_ecs_task_definition" "task_def" {
  family                   = "Wreckfest"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "server",
    "image": "${aws_ecr_repository.repo.repository_url}:latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "environment": [
      {
        "name": "SERVER_NAME", "value": "TheNom"
      },
      {
        "name": "WELCOME_MESSAGE", "value": "Howdy!"
      },
      {
        "name": "GAME_PASSWORD", "value": "flibble"
      },
      {
        "name": "ADMIN_STEAM_IDS", "value": "${join(",", var.admin_steam_ids)}"
      }
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
  iam_role        = aws_iam_role.task.arn
  depends_on      = [aws_iam_role.task]

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}
