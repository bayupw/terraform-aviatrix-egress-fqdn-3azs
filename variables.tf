variable "aws_account" {}

variable "fqdn_rules" {
  description = "Map of FQDN rules (define as number = 'FQDN, protocol, port, action')"
  type        = map(any)

  default = {
    101 = "*.example.com,tcp,80,Base Policy"
    102 = "*.aviatrix.com,tcp,443,Base Policy"
    103 = "*.terraform.io,tcp,80,Base Policy"
    104 = "*.terraform.io,tcp,443,Base Policy"
  }
}

locals {
  region1 = data.aws_region.current.name
  #region2 = "ap-southeast-2"
}