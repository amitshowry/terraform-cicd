terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "sonarqube" {
  name         = "sonarqube:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "sonarqube" {
  image = docker_image.sonarqube.image_id
  name  = "sonarqube"

  restart = "unless-stopped"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 9000
    external = var.http_port
  }

  env = [
    "SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true"
  ]

  volumes {
    host_path      = var.data_host_path
    container_path = "/opt/sonarqube/data"
  }

  volumes {
    host_path      = var.extensions_host_path
    container_path = "/opt/sonarqube/extensions"
  }

  volumes {
    host_path      = var.conf_host_path
    container_path = "/opt/sonarqube/conf"
  }

  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://${var.host_ip}:${var.http_port}/api/system/status || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

