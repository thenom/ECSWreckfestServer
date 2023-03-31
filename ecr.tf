resource "aws_ecr_repository" "repo" {
  name                 = "wreckfest"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images",
            "selection": {
                "countType": "sinceImagePushed",
                "tagStatus": "untagged",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
