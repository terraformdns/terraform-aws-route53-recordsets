# AWS Route53 DNS Recordsets Module

This module manages DNS recordsets in a given Route53 zone. It is part of
[the `terraformdns` project](https://terraformdns.github.io/).

## Example Usage

```hcl
resource "aws_route53_zone" "example" {
  name = "example.com"
}

module "dns_records" {
  source = "terraformdns/route53-recordsets/aws"

  route53_zone = aws_route53_zone.example
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
```

## Compatibility

When using this module, always use a version constraint that constraints to at
least a single major version. Future major versions may have new or different
required arguments, and may use a different internal structure that could
cause recordsets to be removed and replaced by the next plan.

Although this module can in principle support any record type that Route53
would accept, its own logic is focused on the following record types and so
other record types may misbehave or may see different behavior in future
releases:

* `A`
* `AAAA`
* `CNAME`
* `DNAME`
* `MX`
* `NS`
* `SRV`
* `TXT`

## Arguments

- `route53_zone` is the the zone to add records to. The easiest way to populate
  this is to assign your existing `aws_route53_zone` or `data.aws_route53_zone`
  resource directly, though at minimum it requires only an object with
  `id` and `name` attributes.

  Any existing records in this zone that do not conflict with given recordsets
  will be left unchanged.
- `recordsets` is a list of DNS recordsets in the standard `terraformdns`
  recordset format.

This module requires a default configuration for the `hashicorp/aws` provider.

## Limitations

As with all `terraformdns` modules, this module uses a generic, portable model
of DNS recordsets and therefore it cannot make use of Route53-specific
features such as weighted routing, alias records, etc.

If you need to use Route53-specific features, use the `aws_route53_record`
resource type directly.
