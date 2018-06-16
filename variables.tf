
variable "route53_zone_id" {
  type        = string
  description = "The id of the Route53 zone to add records to."
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS record objects to manage, in the standard terraformdns structure."
}
