
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "example" {
  name = "example.com"
}

module "dns_records" {
  source = "terraformdns/route53-recordsets/aws"
  # TODO: Constrain to a specific minor version before use in production
  # version = "~> N.N"

  route53_zone_id = aws_route53_zone.example.id
  recordsets = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      records = [
        "192.0.2.56",
      ]
    },
    {
      name    = ""
      type    = "MX"
      ttl     = 3600
      records = [
        "1 mail1",
        "5 mail2",
        "5 mail3",
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 3600
      records = [
        "\"v=spf1 ip4:192.0.2.3 include:backoff.${aws_route53_zone.example.name} -all\"",
      ]
    },
    {
      name    = "_sip._tcp"
      type    = "SRV"
      ttl     = 3600
      records = [
        "10 60 5060 sip1",
        "10 20 5060 sip2",
        "10 20 5060 sip3",
        "20  0 5060 sip4",
      ]
    },
  ]
}
