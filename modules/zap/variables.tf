variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "host_ip" {
  description = "Host machine IP address"
  type        = string
}

variable "image_version" {
  description = "ZAP version"
  type        = string
}

variable "http_port" {
  description = "ZAP HTTP port"
  type        = number
}

variable "websocket_port" {
  description = "ZAP Websocket port"
  type        = number
}

variable "work_host_path" {
  description = "ZAP Work volume local host path"
  type        = string
}

