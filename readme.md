* provider.tf: defines (a) the minimum provider version of 4.1.4 and connectivity settings to your Grafana instance.
EDIT THIS FILE with your Service Account token and your new Grafana URL.
* alerts_billing.tf: defines 4 alerts, 3 of which are in a "Paused" state. In your demo, you may want to modify this file, enable all alerts, and "terraform apply"
* apply_folder_permissions.tf: imports our 3 dashboards into 3 newly created folders and applies Team access rights to them. Also of note that we remove the generic "View All" access to the folder so that only users with proper access can see dashboards in these folders.
* change_access_to_grafana_cloud_folder.tf: removes the generic "View All" access to the folder
* datasource_perms.tf: provides query access to only the Marketing team for NGINX/Loki logs and only the Finance team to the TestData datasource.
* datasourceloki.tf, datasourceprometheus.tf, datasourcetestdata.tf: Adds our Prometheus and Loki 101 classroom instances as datasources, and adds a generic TestData datasource as well. Each one is configured differently depending upon credentials.
* financedash.json, itdash.json, marketingdash.json: Our 3 dashboards.
* notif.tf: Adds a contact point (email); a mute timing (monday); and a notification policy tree referencing the contact point and mute timing. To snazz it up, you can add your own Slack contact point.
* teams.tf: This creates your user teams and applies the LDAP groups to the teams as an External Group Sync.
* userrbac.tf: Defines custom user roles. For a "part 2" of the demo, you can add the Kubernetes App to the Marketing team users.
