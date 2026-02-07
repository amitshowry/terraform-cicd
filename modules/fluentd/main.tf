terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

locals {
  fluentd_config_path = abspath("${path.module}/conf/fluent.conf")
  fluentd_config_hash = filesha256(local.fluentd_config_path)
}

resource "docker_image" "fluentd" {
  name = "fluentd:${var.image_version}-custom"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile.fluentd"
    tag        = ["fluentd:${var.image_version}-custom"]

    build_args = {
      FLUENTD_VERSION = var.image_version
    }
  }

  # Force rebuild when configuration changes
  lifecycle {
    replace_triggered_by = [
      terraform_data.fluentd_config_change
    ]
  }
}

resource "terraform_data" "fluentd_config_change" {
  triggers_replace = {
    fluentd_config_hash = local.fluentd_config_hash
  }
}

resource "docker_container" "fluentd" {
  image = docker_image.fluentd.image_id
  name  = "fluentd"

  restart = "unless-stopped"

  networks_advanced {
    name = var.network_name
  }

  # Forward input port — Docker Fluentd logging driver sends logs here
  ports {
    internal = 24224
    external = var.forward_port
    protocol = "tcp"
  }

  ports {
    internal = 24224
    external = var.forward_port
    protocol = "udp"
  }

  env = [
    "FLUENTD_CONF=fluent.conf"
  ]

  healthcheck {
    test     = ["CMD-SHELL", "[ -f /fluentd/etc/fluent.conf ]"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
    start_period = "30s"
  }
}