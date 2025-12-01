// Add a Loki NGINX data source
resource "grafana_data_source" "NGINX" {
  # Required
  type = "loki"
  name = "-- Loki NGINX"
  lifecycle {
    ignore_changes = [json_data_encoded, http_headers]
  }
  # Loki specific
    url = "https://logs-prod-us-central1.grafana.net"
    basic_auth_enabled = true
    basic_auth_username = "3965"
  json_data_encoded  = jsonencode({
    manageAlerts = false
  })
  secure_json_data_encoded = jsonencode({
    basicAuthPassword = "eyJrIjoiZTcyNTc0MTczZWE2MWI5ZDljN2JjODgxNGM2ZWRjM2ExYjI2NGQwYSIsIm4iOiJ3b3Jrc2hvcCIsImlkIjoyNTc1MzR9"
  })
}
