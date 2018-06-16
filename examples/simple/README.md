# AWS Route53 DNS Recordsets Module: Simple Example

This simple example shows the declaration of a DNS zone in Route53 and then
the use of this module to populate it with some example DNS recordsets.

To try this example locally, run the following command from an empty directory:

```
terraform init -from-module=terraformdns/route53-recordsets/aws//examples/simple
```

This command will retrieve the example source code into your current working
directory, along with the latest version of the Route53 recordsets module.

After updating the `provider "aws"` configuration in `example.tf` to choose
a region, and configuring [authentication](https://www.terraform.io/docs/providers/aws/index.html#authentication),
you can create the example resources in the usual way:

```
terraform apply
```

After you have finished with the example, you can destroy the resources it
is managing:

```
terraform destroy
```
