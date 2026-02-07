terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
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
module "network" {
  source = "./modules/network"

  name   = var.network_name
  subnet = var.network_subnet
  gateway = var.network_gateway
}

###########################################################
# Gitea Git Service
###########################################################
module "gitea" {
  source = "./modules/gitea"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version      = var.gitea_version
  http_port           = var.gitea_http_port
  ssh_port            = var.gitea_ssh_port
  disable_registration = var.gitea_disable_registration
  host_path           = var.gitea_host_path

  postgres_version  = var.postgres_gitea_version
  postgres_db       = var.postgres_gitea_db
  postgres_user     = var.postgres_gitea_db_user
  postgres_password = var.postgres_gitea_db_password
  postgres_host_path = var.postgres_gitea_host_path
  postgres_tcp_port  = var.postgres_gitea_tcp_port
}

###########################################################
# Jenkins CI/CD Server + Agent
###########################################################
module "jenkins" {
  source = "./modules/jenkins"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version    = var.jenkins_version
  http_port  = var.jenkins_http_port
  agent_port = var.jenkins_agent_port
  user_id    = var.jenkins_user_id
  host_path  = var.jenkins_host_path

  agent_version  = var.jenkins_agent_version
  agent_host_path = var.jenkins_agent_host_path
  agent_name     = var.jenkins_agent_name
  agent_secret   = var.jenkins_agent_secret
}

###########################################################
# JFrog Artifactory OSS
###########################################################
module "artifactory" {
  source = "./modules/artifactory"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version   = var.artifactory_version
  http_port = var.artifactory_http_port
  ui_port  = var.artifactory_ui_port
  host_path = var.artifactory_host_path

  postgres_version  = var.postgres_artifactory_version
  postgres_db       = var.postgres_artifactory_db
  postgres_user     = var.postgres_artifactory_db_user
  postgres_password = var.postgres_artifactory_db_password
  postgres_host_path = var.postgres_artifactory_host_path
  postgres_tcp_port  = var.postgres_artifactory_tcp_port
}

###########################################################
# SonarQube Community Build 
###########################################################
module "sonarqube" {
  source = "./modules/sonarqube"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version            = var.sonarqube_version
  http_port          = var.sonarqube_http_port
  data_host_path     = var.sonarqube_data_host_path
  extensions_host_path = var.sonarqube_extensions_host_path
  conf_host_path     = var.sonarqube_conf_host_path
}

###########################################################
# Zed Attack Proxy
###########################################################
module "zap" {
  source = "./modules/zap"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version        = var.zap_version
  http_port      = var.zap_http_port
  websocket_port = var.zap_websocket_port
  work_host_path = var.zap_work_host_path
}

###########################################################
# Elasticsearch
###########################################################
module "elasticsearch" {
  source = "./modules/elasticsearch"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version   = var.elasticsearch_version
  http_port       = var.elasticsearch_http_port
  transport_port  = var.elasticsearch_transport_port
  data_host_path  = var.elasticsearch_data_host_path
}

###########################################################
# Kibana
###########################################################
module "kibana" {
  source = "./modules/kibana"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version      = var.kibana_version
  http_port          = var.kibana_http_port
  elasticsearch_host = var.kibana_elasticsearch_host
  elasticsearch_port = var.kibana_elasticsearch_port
}

###########################################################
# Logstash
###########################################################
module "logstash" {
  source = "./modules/logstash"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version    = var.logstash_version
  beats_port       = var.logstash_beats_port
  http_port        = var.logstash_http_port
  monitoring_port  = var.logstash_monitoring_port
}

###########################################################
# Fluentd
###########################################################
module "fluentd" {
  source = "./modules/fluentd"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version = var.fluentd_version
  forward_port  = var.fluentd_forward_port

  depends_on = [
    module.elasticsearch,
    module.logstash
  ]
}

###########################################################
# Caddy Proxy
###########################################################
module "caddy" {
  source = "./modules/caddy"

  network_name = module.network.network_name
  host_ip      = var.host_ip

  image_version    = var.caddy_version
  http_port        = var.caddy_http_port

  depends_on = [
    module.gitea,
    module.jenkins,
    module.elasticsearch,
    module.kibana
  ]
}
