// Add a TestData data source
resource "grafana_data_source" "TestData" {
  # Required
  type = "testdata"
  name = "-- TestData"
  uid = "eegjzoxjwl6gwb"
}
