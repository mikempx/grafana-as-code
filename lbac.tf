
# 6. Allow the Finance team to query the metrics data source
data "grafana_data_source" "prometheus" {
 name = "grafanacloud-demoinfra-prom"
}


resource "grafana_data_source_permission" "finance_team_query_metrics" {
 datasource_uid = data.grafana_data_source.prometheus.uid


 permissions {
   team_id    = grafana_team.finance_team.id
   permission = "Query"
 }
}


# 7. Add a Team-scoped LBAC rule for the Finance team to access metrics with probe=NorthVirginia
resource "grafana_data_source_config_lbac_rules" "finance_team_probe_lbac" {
 datasource_uid = data.grafana_data_source.prometheus.uid


 rules = jsonencode({
   "${grafana_team.finance_team.team_uid}" = [
     "{ \"probe\" = \"NorthVirginia\" }"
   ]
 })
}
