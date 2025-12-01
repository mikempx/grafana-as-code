# First, get the existing folder using a data source
data "grafana_folder" "cloud_folder" {
  title = "GrafanaCloud"
}

# Then override the permissions to be admin-only
resource "grafana_folder_permission" "cloud_folder_permission" {
  folder_uid = data.grafana_folder.cloud_folder.uid
  
  # Only Admin role permission
  permissions {
    role       = "Admin"
    permission = "Admin"
  }
}


