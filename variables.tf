
variable "route53_zone" {
  type = object({
    id   = string
    name = string
  })
  description = "The Route53 zone to add the records to. "
}

variable "recordsets" {
  type = set(object({
    name    = string
    type    = string
    ttl     = number
    records = set(string)
  }))
  description = "Set of DNS record objects to manage, in the standard terraformdns structure."
}
