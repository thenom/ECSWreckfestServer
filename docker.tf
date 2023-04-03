resource "null_resource" "image" {
  triggers = {
    dockerfile_changed = filemd5("./docker/dockerfile")
    script_changed     = filemd5("./docker/start-wreckfest.sh")
  }

  provisioner "local-exec" {
    command = <<EOT
    chmod +x ./docker/start-wreckfest.sh
    docker build -t ${aws_ecr_repository.repo.repository_url}:latest ./docker/
    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-2.amazonaws.com
    docker push ${aws_ecr_repository.repo.repository_url}:latest
    EOT
  }
}
