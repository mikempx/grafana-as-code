resource "grafana_team" "finance_team" {
  name = "Finance"
  preferences { home_dashboard_uid = grafana_dashboard.finance_dashboard.uid }
}

resource "grafana_team_external_group" "finance-team-group" {
  team_id = grafana_team.finance_team.id
  groups = [
    "Finance"
  ]
}

resource "grafana_team" "marketing_team" {
  name = "Marketing"
  preferences {
      home_dashboard_uid = grafana_dashboard.marketing_dashboard.uid
      theme = "light"
      }
}
resource "grafana_team_external_group" "marketing-team-group" {
  team_id = grafana_team.marketing_team.id
  groups = [
    "Marketing"
  ]
}

resource "grafana_team" "it_team" {
  name = "SRE"
}

resource "grafana_team_external_group" "it-team-group" {
  team_id = grafana_team.it_team.id
  groups = [
    "IT"
  ]
}

