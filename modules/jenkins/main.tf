terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "jenkins" {
  name         = "jenkins/jenkins:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "jenkins" {
  name  = "jenkins"
  image = docker_image.jenkins.image_id
  
  restart = "unless-stopped"
  
  user = var.user_id
  
  networks_advanced {
    name = var.network_name
  }
  
  ports {
    internal = 8080
    external = var.http_port
  }
  
  ports {
    internal = 50000
    external = var.agent_port
  }
  
  env = [
    "JAVA_OPTS=-Djenkins.install.runSetupWizard=false",
    "JENKINS_OPTS=--prefix=/jenkins"
  ]
  
  volumes {
    host_path      = var.host_path
    container_path = "/var/jenkins_home"
  }
  
  # Mount Docker socket for Docker-in-Docker (optional but useful)
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  
  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://${var.host_ip}:${var.http_port}/jenkins || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }
}

resource "docker_image" "jenkins_agent" {
  name         = "jenkins/inbound-agent:${var.agent_version}"
  keep_locally = true
}

resource "docker_container" "jenkins_agent" {
  name  = "jenkins-agent"
  image = docker_image.jenkins_agent.image_id
  
  restart = "unless-stopped"

  log_driver = "fluentd"
  log_opts = {
    "fluentd-address" = "localhost:24224"
    "fluentd-async"   = "true"
    "tag"             = "docker.jenkins-agent"
  }

  depends_on = [docker_container.jenkins]
 
  user = var.user_id

  networks_advanced {
    name = var.network_name
  }

  env = [
    "JENKINS_URL=http://${docker_container.jenkins.name}:${var.http_port}/jenkins",
    "JENKINS_AGENT_WORKDIR=/var/jenkins",
    "JENKINS_AGENT_NAME=${var.agent_name}",
    "JENKINS_SECRET=${var.agent_secret}",
    "JENKINS_WEB_SOCKET=true"
  ]
 
  volumes {
    host_path      = var.agent_host_path
    container_path = "/var/jenkins"
  }

  healthcheck {
    test     = ["CMD-SHELL", "grep agent.jar /proc/1/cmdline || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }
}

