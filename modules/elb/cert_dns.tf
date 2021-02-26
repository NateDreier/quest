data "aws_route53_zone" "dns" {
  provider     = aws.region-east-primary
  name         = var.dns-name
  private_zone = false
}

resource "aws_acm_certificate" "quest_lb_https" {
  provider          = aws.region-east-primary
  domain_name       = join(".", ["quest", data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = "Quest-ACM"
  }
}

resource "aws_route53_record" "quest" {
  provider = aws.region-east-primary
  zone_id  = data.aws_route53_zone.dns.zone_id
  name     = join(".", ["quest", data.aws_route53_zone.dns.name])
  type     = "A"
  alias {
    name                   = aws_lb.lb-quest.dns_name
    zone_id                = aws_lb.lb-quest.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.region-east-primary
  for_each = {
    for val in aws_acm_certificate.quest_lb_https.domain_validation_options : val.domain_name => {
      name   = val.resource_record_name
      record = val.resource_record_value
      type   = val.resource_record_type
    }
  }
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.dns.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.region-east-primary
  certificate_arn         = aws_acm_certificate.quest_lb_https.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}