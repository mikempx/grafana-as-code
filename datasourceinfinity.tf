// Add an Infinity data source
resource "grafana_data_source" "infinity" {
  # Required
  type = "yesoreyeram-infinity-datasource"
  name = "-- Infinity"
  uid = "bdktck0gfh4hse"
  # Infinity Specific
  url      = ""
  basic_auth_enabled = false
  basic_auth_username = ""
  json_data_encoded  = jsonencode({
    pdcInjected = true
    globalqueries = []
  }) 
}
