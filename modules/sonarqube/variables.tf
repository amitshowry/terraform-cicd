variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "SonarQube version"
  type        = string
}

variable "http_port" {
  description = "SonarQube HTTP port"
  type        = number
}

variable "data_host_path" {
  description = "SonarQube data volume local host path"
  type        = string
}

variable "extensions_host_path" {
  description = "SonarQube Extensions volume local host path"
  type        = string
}

variable "conf_host_path" {
  description = "SonarQube Conf volume local host path"
  type        = string
}

