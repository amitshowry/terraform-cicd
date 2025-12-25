terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

locals {
  caddyfile_path = abspath("${path.module}/Caddyfile")
  caddyfile_hash = filesha256(local.caddyfile_path)
}

resource "docker_image" "caddy" {
  name = "caddy:local"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile.caddy"
  }

  # Force rebuild when Caddyfile content changes
  lifecycle {
    replace_triggered_by = [
      terraform_data.caddyfile_change
    ]
  }
}

resource "terraform_data" "caddyfile_change" {
  triggers_replace = {
    caddyfile_hash = local.caddyfile_hash
  }
}

resource "docker_container" "caddy" {
  image = docker_image.caddy.image_id
  name  = "caddy"

  restart = "unless-stopped"

  networks_advanced {
    name = var.network_name
  }


  ports {
    internal = 80
    external = var.http_port
    protocol = "tcp"
  }

  healthcheck {
    test        = ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://${var.host_ip}:${var.http_port}/"]
    interval    = "30s"
    timeout     = "10s"
    retries     = 5
    start_period = "30s"
  }
}

