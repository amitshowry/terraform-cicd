terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.25"
    }
  }
}

# Configure Docker provider
provider "docker" {
  host = var.docker_host
}

###########################################################
# Create custom network for all services
###########################################################
resource "docker_network" "devops_network" {
  name   = var.network_name
  driver = "bridge"
  
  ipam_config {
    subnet  = var.network_subnet
    gateway = var.network_gateway
  }
}

###########################################################
# PostgreSQL for Gitea
###########################################################
resource "docker_image" "postgres" {
  name         = "postgres:${var.postgres_version}"
  keep_locally = true
}

resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = docker_image.postgres.image_id
  
  restart = "unless-stopped"
  
  networks_advanced {
    name = docker_network.devops_network.name
  }

  ports {
    internal = 5432
    external = var.postgres_tcp_port
  }
  
  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.gitea_db_name}"
  ]
  
  volumes {
    #volume_name    = docker_volume.postgres_data.name
    host_path = var.postgres_host_path
    container_path = "/var/lib/postgresql/data"
  }
  
  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.postgres_user}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

###########################################################
# Gitea Git Service
###########################################################
resource "docker_image" "gitea" {
  name         = "gitea/gitea:${var.gitea_version}"
  keep_locally = true
}

#resource "docker_volume" "gitea_data" {
#  name = "gitea_data"
#}

resource "docker_container" "gitea" {
  name  = "gitea"
  image = docker_image.gitea.image_id
  
  restart = "unless-stopped"
  
  depends_on = [docker_container.postgres]
  
  networks_advanced {
    name = docker_network.devops_network.name
  }
  
  ports {
    internal = 3000
    external = var.gitea_http_port
  }
  
  ports {
    internal = 22
    external = var.gitea_ssh_port
  }
  
  env = [
    "USER_UID=1000",
    "USER_GID=1000",
    "GITEA__database__DB_TYPE=postgres",
    "GITEA__database__HOST=postgres:5432",
    "GITEA__database__NAME=${var.gitea_db_name}",
    "GITEA__database__USER=${var.postgres_user}",
    "GITEA__database__PASSWD=${var.postgres_password}",
    "GITEA__server__ROOT_URL=http://${var.host_ip}:${var.gitea_http_port}/",
    "GITEA__server__SSH_DOMAIN=${var.host_ip}",
    "GITEA__server__SSH_PORT=${var.gitea_ssh_port}",
    "GITEA__server__DISABLE_SSH=false",
    "GITEA__service__DISABLE_REGISTRATION=${var.gitea_disable_registration}",
    "GITEA__webhook__ALLOWED_HOST_LIST=*"
  ]
  
  volumes {
    #volume_name    = docker_volume.gitea_data.name
    host_path = var.gitea_host_path
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
    test     = ["CMD-SHELL", "curl -f http://localhost:3000 || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }

}

###########################################################
# Jenkins CI/CD Server + Agent
###########################################################
resource "docker_image" "jenkins" {
  name         = "jenkins/jenkins:${var.jenkins_version}"
  keep_locally = true
}

#resource "docker_volume" "jenkins_home" {
#  name = "jenkins_home"
#}

resource "docker_container" "jenkins" {
  name  = "jenkins"
  image = docker_image.jenkins.image_id
  
  restart = "unless-stopped"
  
  user = var.jenkins_user_id
  
  networks_advanced {
    name = docker_network.devops_network.name
  }
  
  ports {
    internal = 8080
    external = var.jenkins_http_port
  }
  
  ports {
    internal = 50000
    external = var.jenkins_agent_port
  }
  
  env = [
    "JAVA_OPTS=-Djenkins.install.runSetupWizard=false",
    "JENKINS_OPTS=--prefix=/jenkins"
  ]
  
  volumes {
#    volume_name    = docker_volume.jenkins_home.name
    host_path = var.jenkins_host_path
    container_path = "/var/jenkins_home"
  }
  
  # Mount Docker socket for Docker-in-Docker (optional but useful)
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  
  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost:8080/jenkins/login || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }
}

resource "docker_image" "jenkins_agent" {
  name         = "jenkins/inbound-agent:${var.jenkins_agent_version}"
  keep_locally = true
}

resource "docker_container" "jenkins_agent" {
  name  = "jenkins-agent"
  image = docker_image.jenkins_agent.image_id
  
  restart = "unless-stopped"

  user = var.jenkins_user_id

  networks_advanced {
    name = docker_network.devops_network.name
  }

  env = [
    "JENKINS_URL=http://jenkins:8080/jenkins",
    "JENKINS_AGENT_NAME=agent1",
    "JENKINS_SECRET=ad95095a8aaed7ccbda72451c0fbbb9e010d6d1c9c0d011b71b4521254171802",
    "JENKINS_AGENT_WORKDIR=/var/jenkins"
  ]

  networks_advanced {
    name = docker_network.devops_network.name
  }
 
  volumes {
    host_path = var.jenkins_agent_host_path
    container_path = "/var/jenkins"
  }
}


###########################################################
# JFrog Artifactory OSS
###########################################################
provider "postgresql" {
  host     = "localhost"
  port     = 5432
  username = "${var.postgres_user}"
  password = "${var.postgres_password}"
  database = "postgres"
  sslmode  = "disable" # Use "require" for SSL
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

data "postgresql_schemas" "artifactory_db" {
  database = "${var.artifactory_db_name}"
  depends_on = [null_resource.wait_for_healthy_postgres]
}

resource "postgresql_database" "artifactory" {
  name = "${var.artifactory_db_name}"

  depends_on = [null_resource.wait_for_healthy_postgres]

  count = data.postgresql_schemas.artifactory_db.schemas == "" ? 1 : 0

  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_image" "artifactory" {
  name         = "releases-docker.jfrog.io/jfrog/artifactory-oss:${var.artifactory_version}"
  keep_locally = true
}

#resource "docker_volume" "artifactory_data" {
#  name = "artifactory_data"
#}

resource "docker_container" "artifactory" {
  name  = "artifactory"
  image = docker_image.artifactory.image_id
  
  restart = "unless-stopped"
  
  networks_advanced {
    name = docker_network.devops_network.name
  }
  
  ports {
    internal = 8081
    external = var.artifactory_http_port
  }
  
  ports {
    internal = 8082
    external = var.artifactory_ui_port
  }
  
  env = [
      "JF_SHARED_DATABASE_TYPE=postgresql",
      "JF_SHARED_DATABASE_DRIVER=org.postgresql.Driver",
      "JF_SHARED_DATABASE_URL=jdbc:postgresql://postgres:5432/${var.artifactory_db_name}",
      "JF_SHARED_DATABASE_USERNAME=${var.postgres_user}",
      "JF_SHARED_DATABASE_PASSWORD=${var.postgres_password}"
#      "JF_ROUTER_ENTRYPOINTS_EXTERNALPORT=${var.artifactory_http_port}"
  ]
  
  volumes {
#    volume_name    = docker_volume.artifactory_data.name
    host_path = var.artifactory_host_path
    container_path = "/var/opt/jfrog/artifactory"
  }
  
  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost:8082/router/api/v1/system/health || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
    start_period = "120s"
  }
  
  depends_on = [
    postgresql_database.artifactory
  ]
}


###########################################################
# SonarQube Community Build 
###########################################################
resource "docker_image" "sonarqube" {
  name         = "sonarqube:${var.sonarqube_version}"
  keep_locally = true
}

resource "docker_container" "sonarqube" {
  image = docker_image.sonarqube.image_id
  name  = "sonarqube"

  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.devops_network.name
  }

  ports {
    internal = 9000
    external = var.sonarqube_http_port
  }

  env = [
    "SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true"
  ]

  volumes {
    host_path      = var.sonarqube_data_host_path
    container_path = "/opt/sonarqube/data"
  }

  volumes {
    host_path      = var.sonarqube_extensions_host_path
    container_path = "/opt/sonarqube/extensions"
  }

  volumes {
    host_path      = var.sonarqube_conf_host_path
    container_path = "/opt/sonarqube/conf"
  }

  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost:9000/api/system/status"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }

}

###########################################################
# Zed Attack Proxy
###########################################################
resource "docker_image" "zap" {
  name         = "zaproxy/zap-stable:${var.zap_version}"
  keep_locally = true
}

resource "docker_container" "zap" {
  image = docker_image.zap.image_id
  name  = "zap"

  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.devops_network.name
  }

  ports {
    internal = var.zap_http_port 
    external = var.zap_http_port
  }

  ports {
    internal = 8090
    external = var.zap_websocket_port
  }

  env = [
    "ZAP_PORT=${var.zap_http_port}"
  ]

  command = [
    "zap.sh", "-daemon", "-host", "0.0.0.0", "-port", "${var.zap_http_port}", "-config", "api.addrs.addr.name=.*", "-config", "api.addrs.addr.regex=true"
  ]

  volumes {
    host_path      = var.zap_work_host_path
    container_path = "/zap/wrk"
  }

  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost:${var.zap_http_port}"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }

}
