
  resource "grafana_rule_group" "My_AlertRule_Group" {
  name             = "Finance Eval Group"
  folder_uid = grafana_folder.Financecollection.uid
  interval_seconds = 60

  rule {
    name      = "Finance Alert"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = grafana_data_source.TestData.uid
      model          = "{\"alias\":\"Data\",\"datasource\":{\"type\":\"grafana-testdata-datasource\",\"uid\":\"eegjzoxjwl6gwb\"},\"hide\":false,\"instant\":true,\"intervalMs\":1000,\"labels\":\"data=finance\",\"max\":7,\"maxDataPoints\":43200,\"min\":5,\"refId\":\"A\",\"scenarioId\":\"random_walk\",\"seriesCount\":1}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[6],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0,0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Description goes here"
      summary     = "Summary alert"
    }
    is_paused = false

    notification_settings {
      contact_point = "My First Contact Point"
      group_by      = null
      mute_timings  = null
    }
  }
}
