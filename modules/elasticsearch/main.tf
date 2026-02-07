terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "elasticsearch" {
  name         = "elasticsearch:${var.image_version}"
  keep_locally = true
}

resource "docker_container" "elasticsearch" {
  image = docker_image.elasticsearch.image_id
  name  = "elasticsearch"

  restart = "unless-stopped"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 9200
    external = var.http_port
  }

  ports {
    internal = 9300
    external = var.transport_port
  }

  env = [
    "discovery.type=single-node",
    "ES_JAVA_OPTS=-Xms512m -Xmx512m",
    "xpack.security.enabled=false",
    "bootstrap.memory_lock=true"
  ]

  ulimit {
    name = "memlock"
    soft = -1
    hard = -1
  }

  ulimit {
    name = "nofile"
    soft = 65536
    hard = 65536
  }

  volumes {
    host_path      = var.data_host_path
    container_path = "/usr/share/elasticsearch/data"
  }

  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost:9200/_cluster/health || exit 1"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

# Create ILM policy — runs on every terraform apply
resource "terraform_data" "ilm_policy" {
  depends_on = [docker_container.elasticsearch]

  triggers_replace = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      until curl -sf http://${var.host_ip}:${var.http_port}/_cluster/health > /dev/null 2>&1; do
        echo "Waiting for Elasticsearch to be ready..."
        sleep 5
      done

      curl -sf -X PUT "http://${var.host_ip}:${var.http_port}/_ilm/policy/logstash-cleanup-policy" \
        -H 'Content-Type: application/json' \
        -d '{
          "policy": {
            "phases": {
              "hot": {
                "min_age": "0ms",
                "actions": {
                  "rollover": {
                    "max_primary_shard_size": "100mb"
                  }
                }
              },
              "delete": {
                "min_age": "0ms",
                "actions": {
                  "delete": {}
                }
              }
            }
          }
        }'

      echo ""
      echo "ILM policy 'logstash-cleanup-policy' created successfully."
    EOT
  }
}

