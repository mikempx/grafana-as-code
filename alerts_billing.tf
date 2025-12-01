resource "grafana_folder" "alerts_folder" {
  title = "Automated alerts folder"
}

resource "grafana_folder_permission" "alertsfolderPermission" {
  folder_uid = grafana_folder.alerts_folder.uid
 permissions {
    role       = "Admin"
    permission = "Admin"
  }
}
resource "grafana_rule_group" "BillingAlerts" {
  name             = "Billing Alerts"
  interval_seconds = 60
  folder_uid = grafana_folder.alerts_folder.uid

  rule {
    name      = "Billable Usage Cost Total"
    condition = "I"

    data {
      ref_id = "A"

      relative_time_range {
        from = 1682857
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"(avg without(monetary) (grafanacloud_org_total_overage{org_id=\\\"276038\\\"}))- (9999999999 * 0) >= 0\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Current Billable Usage Cost\",\"maxDataPoints\":43200,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 1682857
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"(grafanacloud_org_spend_commit_credit_total{org_id=\\\"276038\\\"} > 0)- (9999999999 * 0) >= 0\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Spend Commit Credit Total\",\"maxDataPoints\":43200,\"refId\":\"B\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 1682857
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"avg without(monetary) (grafanacloud_org_bill_credit_fraction{org_id=\\\"276038\\\"})- (2 * 1) >= 0\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Fraction of total credit used this month\",\"maxDataPoints\":43200,\"refId\":\"C\"}"
    }
    data {
      ref_id = "D"

      relative_time_range {
        from = 1682857
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"avg without(monetary) (grafanacloud_org_balance_remaining_credit_total_fraction{org_id=\\\"276038\\\"})- (2 * 1) >= 0\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Credit remaining as fraction of total credit @ month-start\",\"maxDataPoints\":43200,\"refId\":\"D\"}"
    }
    data {
      ref_id = "E"

      relative_time_range {
        from = 1682857
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"(grafanacloud_org_spend_commit_balance_total{org_id=\\\"276038\\\"} > 0)- (9999999999 * 0) >= 0\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Spend Commit Balance @ month-start\",\"maxDataPoints\":43200,\"refId\":\"E\"}"
    }
    data {
      ref_id = "F"

      relative_time_range {
        from = 1682857
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"grafanacloud_org_contract_start_date{org_id=\\\"276038\\\"} * 1000\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Contract Start Date\",\"maxDataPoints\":43200,\"refId\":\"F\"}"
    }
    data {
      ref_id = "G"

      relative_time_range {
        from = 1682857
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"grafanacloud_org_contract_end_date{org_id=\\\"276038\\\"} * 1000\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Contract End Date\",\"maxDataPoints\":43200,\"refId\":\"G\"}"
    }
    data {
      ref_id = "H"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"H\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"H\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "I"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[50000],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"I\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"H\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"I\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      __dashboardUid__ = "nQP2eL4Gz"
      __panelId__      = "2"
      description      = "Your usage consumption is currently higher than the alert threshold. To make sure that it’s not a result of very high cardinality or a misconfiguration, refer to the cardinality dashboard. Alternatively, revise your monthly budget."
      summary          = "If the current situation continues, the cost threshold that you set will be exceeded."
    }
    is_paused = false

    notification_settings {
      contact_point = "My First Contact Point"
      group_by      = null
      mute_timings  = null
    }
  }
  rule {
    name      = "Metrics Usage Cost Alerts"
    condition = "D"

    data {
      ref_id = "A"

      relative_time_range {
        from = 1683219
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"avg without(monetary) (grafanacloud_org_metrics_overage{org_id=\\\"276038\\\"})- (9999999999 * 0) >= 0\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Current Metrics Usage Cost\",\"maxDataPoints\":43200,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 1683219
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"avg without(monetary) (grafanacloud_org_metrics_bill_fraction{org_id=\\\"276038\\\"})- (2 * 1) >= 0\",\"instant\":true,\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"Current fraction of cost due to metrics\",\"maxDataPoints\":43200,\"refId\":\"B\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"C\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "D"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[40000],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"D\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"C\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"D\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      __dashboardUid__ = "nQP2eL4Gz"
      __panelId__      = "9"
      description      = "Checks if we are above 40000"
      summary          = "Metrics above 40000"
    }
    is_paused = true

    notification_settings {
      contact_point = "My First Contact Point"
      group_by      = null
      mute_timings  = null
    }
  }
  rule {
    name      = "Active series alert"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"editorMode\":\"code\",\"expr\":\"( sum(grafanacloud_instance_active_series) * sum (grafanacloud_org_metrics_overage) / sum (grafanacloud_org_metrics_billable_series) )\",\"hide\":false,\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"B\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[10000],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "Active series above 10000"
      summary     = "Active series above 10000"
    }
    is_paused = true

    notification_settings {
      contact_point = "My First Contact Point"
      group_by      = null
      mute_timings  = null
    }
  }
  rule {
    name      = "Metrics Active Series Ingestion Rate per Minute (DPM)"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 86400
        to   = 0
      }

      datasource_uid = "grafanacloud-usage"
      model          = "{\"adhocFilters\":[],\"datasource\":{\"type\":\"prometheus\",\"uid\":\"grafanacloud-usage\"},\"expr\":\"max(grafanacloud_instance_samples_per_second{id=~\\\"(1021387|1021388|1193406|1193407|1213460|1213461|1492959|1492960|1511807|1511808|1615519|1615520|1766605|1766606|181237|181238|590153|8954|8955|965095|965096|974153|974154)\\\"} * 60) by (id) * on(id) group_left(name) grafanacloud_instance_info{id=~\\\"(1021387|1021388|1193406|1193407|1213460|1213461|1492959|1492960|1511807|1511808|1615519|1615520|1766605|1766606|181237|181238|590153|8954|8955|965095|965096|974153|974154)\\\"}\",\"interval\":\"\",\"intervalMs\":15000,\"legendFormat\":\"{{ name }}\",\"maxDataPoints\":43200,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"B\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[1750000],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description      = "more than 1.75m"
      summary          = "more than 1.75m"
    }
    is_paused = true

    notification_settings {
      contact_point = "My First Contact Point"
      group_by      = null
      mute_timings  = null
    }
  }
}
