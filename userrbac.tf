resource "grafana_role" "limited_viewer" {
  name        = "limited_viewer"
  description = "Limited viewer with no access to applications or alerts"
  version     = 18
  uid         = "limited-viewer-role"
  global      = true

  # Grant access to specific apps only
  permissions {
    action = "plugins.app:access"
    scope  = "plugins:id:cloud-home-app"  # Replace with actual app ID you want to allow
  }
}

# assign to a team
resource "grafana_role_assignment" "team_limited_role" {
  role_uid = grafana_role.limited_viewer.uid
  teams    = [grafana_team.finance_team.id]
  depends_on = [grafana_team.finance_team, grafana_role.limited_viewer]
}


resource "grafana_role" "reports" {
  name        = "reports"
  description = "Viewer with access to Create and Send Reports"
  version     = 12
  uid         = "reports-role"
  global      = true
  # NOTE: you need to increase the role's version 3 lines above here modifying a custom role
  permissions {
    action = "reports:create"
  }
  permissions {
    action = "reports:write"
    scope  = "reports:*"
  }
  permissions {
    action = "reports:read"
    scope  = "reports:*"
  }
  permissions {
    action = "reports:send"
    scope  = "reports:*"
  }
}
# Assign Reporting to the MARKETING team
resource "grafana_role_assignment" "team_reports" {
  role_uid = grafana_role.reports.uid
  teams    = [grafana_team.marketing_team.id]
  depends_on = [grafana_team.marketing_team, grafana_role.reports]
}

resource "grafana_role" "additional_apps" {
  name        = "additional_apps"
  description = "Viewer with access to the K8s application"
  version     = 11
  uid         = "additional-apps-role"
  global      = true

  # Grant access to Reporting and perhaps some "Apps" but not others
  # Allow access to dashboards app but not others
  permissions {
    # NOTE: you need to increase the role's version a few lines here after modifying a custom role
    action = "plugins.app:access"
    scope  = "plugins:id:grafana-k8s-app"
    //scope  = "plugins:id:grafana-app-observability-app" # App O11y
    //scope  = "plugins:id:grafana-slo-app"               # SLO
    //scope  = "plugins:id:grafana-incident-app"          # Incident
    //scope  = "plugins:id:grafana-oncall-app"            # OnCall
    //scope  = "plugins:id:k6-app"                        # K6
    //scope  = "plugins:id:grafana-adaptive-metrics-app"  # Adaptive Telemetry
  }
}
# Assign Apps to the MARKETING team
//resource "grafana_role_assignment" "team_additional_apps" {
//  role_uid = grafana_role.additional_apps.uid
//  teams    = [grafana_team.marketing_team.id]
//  depends_on = [grafana_team.marketing_team, grafana_role.additional_apps]
//}

