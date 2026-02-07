terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

module "postgres" {
  source = "../postgres"

  network_name   = var.network_name
  image_version   = var.postgres_version
  db_name        = var.postgres_db
  user           = var.postgres_user
  password       = var.postgres_password
  host_path      = var.postgres_host_path
  tcp_port       = var.postgres_tcp_port
  container_name = "postgres-artifactory"
}

resource "docker_image" "artifactory" {
  name         = "releases-docker.jfrog.io/jfrog/artifactory-oss:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "artifactory" {
  name  = "artifactory"
  image = docker_image.artifactory.image_id
  
  restart = "unless-stopped"

  log_driver = "fluentd"
  log_opts = {
    "fluentd-address" = "localhost:24224"
    "fluentd-async"   = "true"
    "tag"             = "docker.artifactory"
  }
 
  depends_on = [module.postgres]

  networks_advanced {
    name = var.network_name
  }
  
  ports {
    internal = 8081
    external = var.http_port
  }
  
  ports {
    internal = 8082
    external = var.ui_port
  }
  
  env = [
    "JF_SHARED_DATABASE_TYPE=postgresql",
    "JF_SHARED_DATABASE_DRIVER=org.postgresql.Driver",
    "JF_SHARED_DATABASE_URL=jdbc:postgresql://${module.postgres.db_host}:5432/${var.postgres_db}",
    "JF_SHARED_DATABASE_USERNAME=${var.postgres_user}",
    "JF_SHARED_DATABASE_PASSWORD=${var.postgres_password}"
  ]
  
  volumes {
    host_path      = var.host_path
    container_path = "/var/opt/jfrog/artifactory"
  }
  
  healthcheck {
    test        = ["CMD-SHELL", "curl -f http://${var.host_ip}:${var.ui_port}/router/api/v1/system/health || exit 1"]
    interval    = "30s"
    timeout     = "10s"
    retries     = 5
    start_period = "2m0s"
  }
}

