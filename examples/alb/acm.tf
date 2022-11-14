resource "aws_acm_certificate" "default" {
  provider          = aws.testing
  domain_name       = "testing.atapi.net"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "default" {
  provider = aws.automation

  name         = "atapi.net"
  private_zone = false
}


resource "aws_route53_record" "default" {
  provider = aws.automation

  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 600
  type            = each.value.type
  zone_id         = data.aws_route53_zone.default.zone_id
}

resource "aws_acm_certificate_validation" "default" {
  provider                = aws.testing
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [for record in aws_route53_record.default : record.fqdn]
}