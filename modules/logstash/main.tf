terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

locals {
  pipeline_config_path = abspath("${path.module}/pipeline/logstash.conf")
  pipeline_config_hash = filesha256(local.pipeline_config_path)
}

resource "docker_image" "logstash" {
  name = "logstash:${var.image_version}-custom"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile.logstash"
    tag        = ["logstash:${var.image_version}-custom"]
    
    build_args = {
      LOGSTASH = var.image_version
    }
  }

  # Force rebuild when pipeline configuration changes
  lifecycle {
    replace_triggered_by = [
      terraform_data.pipeline_config_change
    ]
  }
}

resource "terraform_data" "pipeline_config_change" {
  triggers_replace = {
    pipeline_config_hash = local.pipeline_config_hash
  }
}

resource "docker_container" "logstash" {
  image = docker_image.logstash.image_id
  name  = "logstash"

  restart = "unless-stopped"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 5044
    external = var.beats_port
  }

  ports {
    internal = 8085
    external = var.http_port
  }

  ports {
    internal = 9600
    external = var.monitoring_port
  }

  env = [
    "LS_JAVA_OPTS=-Xmx256m -Xms256m",
    "XPACK_MONITORING_ENABLED=false"
  ]
  
  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost:9600/_node/stats || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
    start_period = "1m0s"
  }
}

