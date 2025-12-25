terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "zap" {
  name         = "zaproxy/zap-stable:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "zap" {
  image = docker_image.zap.image_id
  name  = "zap"

  restart = "unless-stopped"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = var.http_port
    external = var.http_port
  }

  ports {
    internal = 8090
    external = var.websocket_port
  }

  env = [
    "ZAP_PORT=${var.http_port}"
  ]

  command = [
    "zap.sh", "-daemon", "-host", "0.0.0.0", "-port", "${var.http_port}", "-config", "api.addrs.addr.name=.*", "-config", "api.addrs.addr.regex=true"
  ]

  volumes {
    host_path      = var.work_host_path
    container_path = "/zap/wrk"
  }

  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://${var.host_ip}:${var.http_port} || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

