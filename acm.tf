resource "aws_acm_certificate" "site_cert" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  tags = {
    Environment = local.env_tag
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "site_cert_vald" {
  certificate_arn         = aws_acm_certificate.site_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.site_cert_vald_rec : record.fqdn]
}

