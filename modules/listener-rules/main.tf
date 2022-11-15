resource "aws_lb_listener_rule" "this" {
  count = length(var.listener_rules)

  listener_arn = var.listener_arn
  dynamic "action" {
    for_each = [
      for action_rule in var.listener_rules[count.index].actions :
      action_rule
      if action_rule.type == "redirect"
    ]

    content {
      type = action.value["type"]
      redirect {
        host        = lookup(action.value, "host", null)
        path        = lookup(action.value, "path", null)
        port        = lookup(action.value, "port", null)
        protocol    = lookup(action.value, "protocol", null)
        query       = lookup(action.value, "query", null)
        status_code = action.value["status_code"]
      }
    }
  }

  dynamic "action" {
    for_each = [
      for action_rule in var.listener_rules[count.index].actions :
      action_rule
      if action_rule.type == "forward"
    ]

    content {
      type             = action.value["type"]
      target_group_arn = lookup(action.value, "target_group_arn", var.target_group_arn)
    }
  }

  dynamic "condition" {
    for_each = [
      for condition_rule in var.listener_rules[count.index].conditions :
      condition_rule
      if length(lookup(condition_rule, "path_patterns", [])) > 0
    ]

    content {
      path_pattern {
        values = condition.value["path_patterns"]
      }
    }
  }
  tags = merge(var.tags, {
    "elbv2.k8s.aws/cluster" = var.eks_cluster_name
  })
}


