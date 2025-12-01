
// Add an IT folder
resource "grafana_folder" "ITcollection" {
  title = "IT's automated folder"
}
// Add a Finance folder
resource "grafana_folder" "Financecollection" {
  title = "FINANCE's automated folder"
}
// Add a Marketing folder
resource "grafana_folder" "Marketingcollection" {
  title = "MARKETING's automated folder"
}

// Add our MARKETING dashboards to the Marketing folder
resource "grafana_dashboard" "marketing_dashboard" {
  config_json = file("marketingdash.json")
  # Place it inside a folder; see resource below
  folder = grafana_folder.Marketingcollection.id
}
resource "grafana_dashboard" "app1" {
  config_json = file("app1.json")
  folder = grafana_folder.Marketingcollection.id
}
// Add a Finance dashboard to the Finance folder
resource "grafana_dashboard" "finance_dashboard" {
  config_json = file("financedash.json")

  # Place it inside a folder; see resource below
  folder = grafana_folder.Financecollection.id
}

// Add the IT dashboard to the IT folder
resource "grafana_dashboard" "it_dashboard" {
  config_json = file("itdash.json")

  # Place it inside a folder; see resource below
  folder = grafana_folder.ITcollection.id
}

# Override default permissions of the Finance Team folder
# NOTE: the addition of generic "Admin" privileges remove the automatic Editor and Viewer default access
resource "grafana_folder_permission" "my_FINANCE_folder_permission" {
  folder_uid = grafana_folder.Financecollection.uid
  permissions {
    role       = "Admin"
    permission = "Admin"
  }
  # Finance Team with viewer permission
  permissions {
    team_id    = grafana_team.finance_team.id
    permission = "View"
  }
}

# Override default permissions for the Marketing Team
# NOTE: the addition of generic "Admin" privileges remove the automatic Editor and Viewer default access
resource "grafana_folder_permission" "my_MARKETING_folder_permission" {
  folder_uid = grafana_folder.Marketingcollection.uid
  permissions {
    role       = "Admin"
    permission = "Admin"
  }
  # Marketing Team with view permissions
  permissions {
    team_id    = grafana_team.marketing_team.id
    permission = "View"
  }
}
# Override default permissions for the IT/SRE Team
# NOTE: the addition of generic "Admin" privileges remove the automatic Editor and Viewer default access
resource "grafana_folder_permission" "my_IT_folder_permission" {
  folder_uid = grafana_folder.ITcollection.uid
  permissions {
    role       = "Admin"
    permission = "Admin"
  }
  # IT Team with admin permission
  permissions {
    team_id    = grafana_team.it_team.id
    permission = "Admin"
  }
}
