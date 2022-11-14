resource "aws_lb_listener_rule" "tfer--arn-003A-aws-003A-elasticloadbalancing-003A-eu-west-2-003A-790762862953-003A-listener-rule-002F-app-002F-k8s-ingressn-albingre-d07e09a987-002F-b310e7be3a298794-002F-564366f6c33ed418-002F-2cc789aa235202bb" {
  action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:eu-west-2:790762862953:targetgroup/k8s-ingressn-automati-d18d47737a/ef91af6dd5a882d1"
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  listener_arn = "${data.terraform_remote_state.alb.outputs.aws_lb_listener_tfer--arn-003A-aws-003A-elasticloadbalancing-003A-eu-west-2-003A-790762862953-003A-listener-002F-app-002F-k8s-ingressn-albingre-d07e09a987-002F-b310e7be3a298794-002F-564366f6c33ed418_id}"
  priority     = "1"

  tags = {
    "elbv2.k8s.aws/cluster"    = "automation-eks-github-runners"
    "ingress.k8s.aws/resource" = "443:1"
    "ingress.k8s.aws/stack"    = "ingress-nginx/alb-ingress-controller"
  }

  tags_all = {
    "elbv2.k8s.aws/cluster"    = "automation-eks-github-runners"
    "ingress.k8s.aws/resource" = "443:1"
    "ingress.k8s.aws/stack"    = "ingress-nginx/alb-ingress-controller"
  }
}

resource "aws_lb_listener_rule" "tfer--arn-003A-aws-003A-elasticloadbalancing-003A-eu-west-2-003A-790762862953-003A-listener-rule-002F-app-002F-k8s-ingressn-albingre-d07e09a987-002F-b310e7be3a298794-002F-f526561fd17cfeef-002F-b32be2aeb4bd2df9" {
  action {
    order = "1"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }

    type = "redirect"
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  listener_arn = "${data.terraform_remote_state.alb.outputs.aws_lb_listener_tfer--arn-003A-aws-003A-elasticloadbalancing-003A-eu-west-2-003A-790762862953-003A-listener-002F-app-002F-k8s-ingressn-albingre-d07e09a987-002F-b310e7be3a298794-002F-f526561fd17cfeef_id}"
  priority     = "1"

  tags = {
    "elbv2.k8s.aws/cluster"    = "automation-eks-github-runners"
    "ingress.k8s.aws/resource" = "80:1"
    "ingress.k8s.aws/stack"    = "ingress-nginx/alb-ingress-controller"
  }

  tags_all = {
    "elbv2.k8s.aws/cluster"    = "automation-eks-github-runners"
    "ingress.k8s.aws/resource" = "80:1"
    "ingress.k8s.aws/stack"    = "ingress-nginx/alb-ingress-controller"
  }
}
