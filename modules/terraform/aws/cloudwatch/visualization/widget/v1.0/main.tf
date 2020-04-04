locals {
  namespaced_metric = "${list("${var.namespace}", "${var.metric_name}")}"
}


data "template_file" "metric" {
  count = "${length(var.dimensions)}"
  template = "$${dims}"

  vars = {
    dims = "${jsonencode( concat( local.namespaced_metric, split(",", replace(var.dimensions[count.index], ", ", ",")) ) )}"
  }
}

data "template_file" "metrics" {
  template = "[$${list_of_metrics}]"

  vars = {
    list_of_metrics = "${join(", ", data.template_file.metric.*.rendered)}"
  }
}

data "template_file" "properties" {
  template = "${file("${path.module}/files/properties.json")}"
  vars = {
    metrics = "${data.template_file.metrics.rendered}"
    period = "${var.period}"
    region = "${var.region}"
    stacked = "${var.stacked ? "true" : "false"}"
    stat = "${var.stat}"
    title = "${var.title == 0 ? "${var.namespace} ${var.metric_name}" : var.title}"
    view = "${var.view}"
  }
}

data "template_file" "widget" {
  template = "${file("${path.module}/files/widget.json")}"
  vars = {
    width = "${var.width}"
    height = "${var.height}"
    properties = "${data.template_file.properties.rendered}"
  }
}

/*
data "template_file" "dashboard_body" {
  template = "${file("${path.module}/files/dashboard.json")}"

  vars = {
    widgets_json = "${join(",", data.template_file.widget.*.rendered)}"
  }
}*/
