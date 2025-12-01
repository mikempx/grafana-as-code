resource "grafana_rule_group" "rule_group_461caf519df17bc4" {
  name             = "Marketing Eval Group"
  folder_uid = grafana_folder.Marketingcollection.uid
  interval_seconds = 60

  rule {
    name      = "NGINX load by HTTP status"
    condition = "C"

    data {
      ref_id     = "A"
      query_type = "range"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = grafana_data_source.NGINX.uid
      model          = "{\"datasource\":{\"type\":\"loki\",\"uid\":\"eeh4dbp9wdreof\"},\"editorMode\":\"builder\",\"expr\":\"sum by(host, status) (rate({host=\\\"appfelstrudel\\\"} |= `` | json | __error__=`` [$__auto]))\",\"hide\":false,\"instant\":true,\"intervalMs\":1000,\"maxDataPoints\":43200,\"queryType\":\"range\",\"refId\":\"A\"}"
    }
    data {
      ref_id     = "B"
      query_type = "expression"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0,0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[1.17],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "NoData"
    exec_err_state = "Error"
    annotations = {
      description = "Load on host {{ $labels.host }} has exceeded 1.17 requests/sec for HTTP Status {{ $labels.status }} .  Current Value: {{ $values.A.Value }}/sec for the last minute."
      summary     = "Load on host {{ $labels.host }} has exceeded 1.17 requests/sec"
    }
    is_paused = false

    notification_settings {
      contact_point = "grafana-default-email"
      group_by      = null
      mute_timings  = null
    }
  }
}
