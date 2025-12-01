// Install and configure the provider
terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 4.1.14"  # Latest version as of my knowledge
    }
  }
}

provider "grafana" {
url = "https://xyz.grafana.net/" # your Grafana Cloud URL
auth = "glsa_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"    #your SERVICE ACCOUNT token
}

