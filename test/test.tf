resource "aws_route53_zone" "test" {
  name = "terraformdns-test.com"
}

module "main" {
  source = "../"

  route53_zone = aws_route53_zone.test
  recordsets = [
    {
      name = ""
      type = "TXT"
      ttl  = 1
      records = [
        "hello world",
      ]
    },
    {
      name = "foo"
      type = "TXT"
      ttl  = 1
      records = [
        "This is foo",
      ]
    },
    {
      name = "boop"
      type = "A"
      ttl  = 1
      records = [
        "192.168.1.1",
        "192.168.1.2",
      ]
    },
    {
      name = "boop2"
      type = "CNAME"
      ttl  = 1
      records = [
        "boop",
      ]
    },
    {
      name = "boop3"
      type = "CNAME"
      ttl  = 1
      records = [
        "boop.${aws_route53_zone.test.name}.",
      ]
    },
    {
      name = "_foo._tcp"
      type = "SRV"
      ttl  = 1
      records = [
        "1 2 3 boop",
      ]
    },
    {
      name = ""
      type = "MX"
      ttl  = 1
      records = [
        "1 boop",
      ]
    },
  ]
}

data "testing_tap" "result" {
  program = ["bash", "${path.module}/test.sh"]

  environment = {
    NAMESERVER = aws_route53_zone.test.name_servers[0]
    DOMAIN     = aws_route53_zone.test.name
  }

  depends_on = [
    aws_route53_zone.test,
    module.main,
  ]
}
