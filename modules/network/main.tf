terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_network" "devops_network" {
  name   = var.name
  driver = "bridge"
  
  ipam_config {
    subnet  = var.subnet
    gateway = var.gateway
  }
}

