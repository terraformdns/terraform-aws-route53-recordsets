
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = ">= 1.15.0"
  }
}

data "aws_route53_zone" "container" {
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "this" {
  count = length(var.recordsets)

  zone_id = data.aws_route53_zone.container.zone_id

  name = (
    var.recordsets[count.index].name != "" ?
    "${var.recordsets[count.index].name}.${data.aws_route53_zone.container.name}" :
    data.aws_route53_zone.container.name
  )
  type = var.recordsets[count.index].type
  ttl  = var.recordsets[count.index].ttl

  records = var.recordsets[count.index].records
}
