// Add a Prometheus data source
resource "grafana_data_source" "prometheus" {
  # Required
  type = "prometheus"
  name = "-- Prometheus"
  uid = "eegjhugd9tfcwe"
  # Prometheus specific
  url      = "http://34.121.40.211:9090/"
  json_data_encoded  = jsonencode({
    manageAlerts = false
  }) 
}
