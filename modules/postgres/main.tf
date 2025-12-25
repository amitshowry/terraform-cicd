terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "postgres" {
  name         = "postgres:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "postgres" {
  name  = var.container_name
  image = docker_image.postgres.image_id
  
  restart = "unless-stopped"
  
  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 5432
    external = var.tcp_port
  }
  
  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.user}",
    "POSTGRES_PASSWORD=${var.password}"
  ]
  
  volumes {
    host_path      = var.host_path
    container_path = "/var/lib/postgresql/data"
  }

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.user}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

resource "null_resource" "wait_for_healthy_postgres" {
  depends_on = [docker_container.postgres]

  provisioner "local-exec" {
    command = <<EOT
      until [ "$(docker inspect --format='{{.State.Health.Status}}' ${docker_container.postgres.id})" = "healthy" ]; do
        echo "Waiting for container to be healthy..."
        sleep 5
      done
      echo "Container is healthy!"
    EOT
  }
}

