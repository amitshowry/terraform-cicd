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
  container_name = "postgres-gitea"
}

resource "docker_image" "gitea" {
  name         = "gitea/gitea:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "gitea" {
  name  = "gitea"
  image = docker_image.gitea.image_id
  
  restart = "unless-stopped"
  
  depends_on = [module.postgres]
  
  networks_advanced {
    name = var.network_name
  }
  
  ports {
    internal = 3000
    external = var.http_port
  }
  
  ports {
    internal = 22
    external = var.ssh_port
  }
  
  env = [
    "USER_UID=1000",
    "USER_GID=1000",
    "GITEA__database__DB_TYPE=postgres",
    "GITEA__database__HOST=${module.postgres.db_host}:5432",
    "GITEA__database__NAME=${var.postgres_db}",
    "GITEA__database__USER=${var.postgres_user}",
    "GITEA__database__PASSWD=${var.postgres_password}",
    "GITEA__server__ROOT_URL=http://${var.host_ip}/gitea",
    "GITEA__server__SSH_DOMAIN=${var.host_ip}",
    "GITEA__server__SSH_PORT=${var.ssh_port}",
    "GITEA__server__DISABLE_SSH=false",
    "GITEA__service__DISABLE_REGISTRATION=${var.disable_registration}",
    "GITEA__webhook__ALLOWED_HOST_LIST=*"
  ]
  
  volumes {
    host_path      = var.host_path
    container_path = "/data"
  }
  
  volumes {
    host_path      = "/etc/timezone"
    container_path = "/etc/timezone"
    read_only      = true
  }
  
  volumes {
    host_path      = "/etc/localtime"
    container_path = "/etc/localtime"
    read_only      = true
  }

  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://${var.host_ip}:${var.http_port} || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }
}

