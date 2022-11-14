
data "aws_s3_object" "automation" {
  bucket = "axetrading-infrastructure-metadata"
  key    = "automation.yaml"
}

data "aws_s3_object" "testing" {
  bucket = "axetrading-infrastructure-metadata"
  key    = "testing_london.yaml"
}
locals {
  assume_role = "arn:aws:iam::915900423568:role/terraform-iac-role"
  automation  = yamldecode(data.aws_s3_object.automation.body).automation
  testing     = yamldecode(data.aws_s3_object.testing.body).testing_london
}

module "testing_eks_cluster_alb" {
  source                = "../../"
  name                  = "testing-load-balancer"
  vpc_id                = local.testing.vpc_id
  subnets               = local.testing.private_subnet_ids
  load_balancer_type    = "application"
  create_security_group = true
  security_group_name   = "testing-load-balancer-sg"
  lb_listeners = {
    http_80 = {
      listener_port     = 80
      listener_protocol = "HTTP"
    }
    https_443 = {
      listener_port     = 443
      listener_protocol = "HTTPS"
      certificate_arn   = aws_acm_certificate.default.arn
    }
  }
  security_group_rules = {
    ingress_443 = {
      description = "Allow inbound from VPN "
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.187.0.0/22", "10.187.12.0/22"]
    }
  }

  target_groups = {
    "hello-world-application" = {
      name = module.target_group_name_prefix.result
    }
  }

  providers = {
    aws = aws.testing
  }

}

resource "aws_route53_record" "testing" {
  provider = aws.automation
  zone_id  = data.aws_route53_zone.default.zone_id
  name     = "testing.atapi.net"
  type     = "A"
  alias {
    name                   = module.testing_eks_cluster_alb.dns_name
    zone_id                = module.testing_eks_cluster_alb.zone_id
    evaluate_target_health = true
  }
}

module "target_group_name_prefix" {
  source     = "axetrading/short-name/null"
  version    = "1.0.0"
  value      = "hello-world-api-target-group"
  max_length = 32
  separator  = "-"
}

output "target" {
  value = module.target_group_name_prefix.result
}

#module "hello_world_target_group" {
#  source = "./../../modules/target-groups/"
#  name   = module.target_group_name_prefix.result
#}