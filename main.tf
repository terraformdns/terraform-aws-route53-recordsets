
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = ">= 1.15.0"
  }
}

module "normalize" {
  source = "terraformdns/normalize-recordsets/template"

  target_zone_name = var.route53_zone.name
  recordsets       = var.recordsets
}

locals {
  recordsets = {
    for rs in module.normalize.normalized : "${rs.name} ${rs.type}" => rs
  }
}

resource "aws_route53_record" "this" {
  for_each = local.recordsets

  zone_id = var.route53_zone.id

  name = (
    each.value.name != "" ?
    "${each.value.name}.${var.route53_zone.name}" :
    var.route53_zone.name
  )
  type = each.value.type
  ttl  = each.value.ttl

  records = each.value.records
}
