# Test Configuration

This directory contains a Terraform configuration that tests the module
in the root directory using
[the `testing` provider](https://registry.terraform.io/providers/apparentlymart/testing).
Because that provider is not a HashiCorp-official one, this configuration
requires Terraform 0.13 or later even though the module under test only
requires Terraform 0.12 or later.

The test case also includes a Bash script which makes DNS lookups using the
`dig` command line tool, so both `bash` and `dig` must be available in your
`PATH` to successfully use this configuration.

You can use this configuration as normal to run the test:

* `terraform init` to install the required dependencies
* `terraform apply` to create the test objects and run the test assertions
* `terraform destroy` when you're done, to clean up the test objects

The successful completion of `terraform apply` indicates that the tests are
all passing.
