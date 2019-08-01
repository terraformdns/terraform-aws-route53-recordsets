
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = ">= 1.15.0"
  }
}

locals {
  recordsets = {
    for rs in var.recordsets : "${rs.name} ${rs.type}" => rs
  }
}

data "aws_route53_zone" "container" {
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "this" {
  for_each = local.recordsets

  zone_id = data.aws_route53_zone.container.zone_id

  name = (
    each.value.name != "" ?
    "${each.value.name}.${data.aws_route53_zone.container.name}" :
    data.aws_route53_zone.container.name
  )
  type = each.value.type
  ttl  = each.value.ttl

  records = each.value.records
}
