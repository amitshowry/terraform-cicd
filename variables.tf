variable "docker_host" {
  description = "Docker daemon host"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "network_name" {
  description = "Docker network name"
  type        = string
  default     = "devops_network"
}

variable "network_subnet" {
  description = "Docker network subnet"
  type        = string
  default     = "172.20.0.0/16"
}

variable "network_gateway" {
  description = "Docker network gateway"
  type        = string
  default     = "172.20.0.1"
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
  default     = "localhost"
}

# Gitea PostgreSQL Configuration
variable "postgres_gitea_version" {
  description = "Gitea PostgreSQL version"
  type        = string
  default     = "15-alpine"
}

variable "postgres_gitea_db" {
  description = "Gitea PostgreSQL database name"
  type        = string
  default     = "gitea"
}

variable "postgres_gitea_db_user" {
  description = "Gitea PostgreSQL user"
  type        = string
  default     = "gitea"
  sensitive   = true
}

variable "postgres_gitea_db_password" {
  description = "Gitea PostgreSQL password"
  type        = string
  default     = "password"
  sensitive   = true
}

variable "postgres_gitea_host_path" {
  description = "Git PostgreSQL data volume local host path"
  type        = string
  default     = "/tmp/postgres-gitea-data"
}

variable "postgres_gitea_tcp_port" {
  description = "Gitea PostgreSQL TCP port"
  type        = number
  default     = 5432
}

# Gitea Configuration
variable "gitea_version" {
  description = "Gitea version"
  type        = string
  default     = "1.21"
}

variable "gitea_http_port" {
  description = "Gitea HTTP port"
  type        = number
  default     = 3000
}

variable "gitea_ssh_port" {
  description = "Gitea SSH port"
  type        = number
  default     = 3022
}

variable "gitea_disable_registration" {
  description = "Disable public registration"
  type        = string
  default     = "false"
}

variable "gitea_host_path" {
  description = "Gitea data volume local host path"
  type        = string
  default     = "/tmp/gitea-data"
}

# Jenkins Configuration
variable "jenkins_version" {
  description = "Jenkins version"
  type        = string
  default     = "lts-jdk17"
}

variable "jenkins_http_port" {
  description = "Jenkins HTTP port"
  type        = number
  default     = 8080
}

variable "jenkins_agent_port" {
  description = "Jenkins agent port"
  type        = number
  default     = 50000
}

variable "jenkins_user_id" {
  description = "Jenkins user ID (UID:GID)"
  type        = string
  default     = "1000:1000"
}

variable "jenkins_host_path" {
  description = "Jenkins data volume local host path"
  type        = string
  default     = "/tmp/jenkins-data"
}

variable "jenkins_agent_version" {
  description = "Jenkins agent version"
  type        = string
  default     = "latest"
}

variable "jenkins_agent_host_path" {
  description = "Jenkins agent data volume local host path"
  type        = string
  default     = "/tmp/jenkins-agent-data"
}

variable "jenkins_agent_name" {
  description = "Jenkins agent name you given at jenkins"
  type        = string
  default     = "agent"
}

variable "jenkins_agent_secret" {
  description = "Jenkins agent secret fetch after jenkins startsup"
  type        = string
  default     = "some-random-secret"
  sensitive   = true
}

# Artifactory PostgreSQL Configuration
variable "postgres_artifactory_version" {
  description = "Artifactory PostgreSQL version"
  type        = string
  default     = "15-alpine"
}

variable "postgres_artifactory_db" {
  description = "Artifactory PostgreSQL database name"
  type        = string
  default     = "artifactory"
}

variable "postgres_artifactory_db_user" {
  description = "Artifactory PostgreSQL user"
  type        = string
  default     = "artifactory"
  sensitive   = true
}

variable "postgres_artifactory_db_password" {
  description = "Artifactory PostgreSQL password"
  type        = string
  default     = "password"
  sensitive   = true
}

variable "postgres_artifactory_host_path" {
  description = "Artifactory PostgreSQL data volume local host path"
  type        = string
  default     = "/tmp/postgres-artifactory-data"
}

variable "postgres_artifactory_tcp_port" {
  description = "Artifactory PostgreSQL TCP port"
  type        = number
  default     = 5432
}

# Artifactory Configuration
variable "artifactory_version" {
  description = "Artifactory version"
  type        = string
  default     = "7.77.3"
}

variable "artifactory_http_port" {
  description = "Artifactory HTTP port"
  type        = number
  default     = 8081
}

variable "artifactory_ui_port" {
  description = "Artifactory UI port"
  type        = number
  default     = 8082
}

variable "artifactory_host_path" {
  description = "Artifactory data volume local host path"
  type        = string
  default     = "/tmp/artifactory-data"
}

# SonarQube Configuration
variable "sonarqube_version" {
  description = "SonarQube version"
  type        = string
  default     = "latest"
}

variable "sonarqube_http_port" {
  description = "SonarQube HTTP port"
  type        = number
  default     = 9000
}

variable "sonarqube_data_host_path" {
  description = "SonarQube data volume local host path"
  type        = string
  default     = "/tmp/sonarqube-data"
}

variable "sonarqube_extensions_host_path" {
  description = "SonarQube Extensions volume local host path"
  type        = string
  default     = "/tmp/sonarqube-ext"
}

variable "sonarqube_conf_host_path" {
  description = "SonarQube Conf volume local host path"
  type        = string
  default     = "/tmp/sonarqube-conf"
}

# Zed Attack Proxy  Configuration
variable "zap_version" {
  description = "ZAP version"
  type        = string
  default     = "latest"
}

variable "zap_http_port" {
  description = "ZAP HTTP port"
  type        = number
  default     = 8084 
}

variable "zap_websocket_port" {
  description = "ZAP Websocket port"
  type        = number
  default     = 8090 
}

variable "zap_work_host_path" {
  description = "ZAP Work volume local host path"
  type        = string
  default     = "/tmp/zap-work"
}

variable "caddy_http_port" {
  description = "Caddy HTTP port"
  type        = number
  default     = 80
}
