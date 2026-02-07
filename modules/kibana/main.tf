terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "kibana" {
  name         = "kibana:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "kibana" {
  image = docker_image.kibana.image_id
  name  = "kibana"

  restart = "unless-stopped"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 5601
    external = var.http_port
  }

  env = [
    "ELASTICSEARCH_HOSTS=http://${var.elasticsearch_host}:${var.elasticsearch_port}",
    "SERVER_NAME=kibana",
    "SERVER_HOST=0.0.0.0"
  ]

  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost:5601/api/status || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
    start_period = "1m0s"
  }
}

