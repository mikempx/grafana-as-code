# Data Source Permissions for Marketing Team
resource "grafana_data_source_permission" "marketing_datasrc_permissions" {
  datasource_uid = grafana_data_source.NGINX.uid
  permissions {
    team_id    = grafana_team.marketing_team.id
    permission = "Query"
  }
}

# Data Source Permissions for Finance Team
resource "grafana_data_source_permission" "finance_datasrc_permissions" {
  datasource_uid = grafana_data_source.TestData.uid
  permissions {
    team_id    = grafana_team.finance_team.id
    permission = "Query"
  }
}

