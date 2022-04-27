/* module "vpc_a" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 3.0"
  name                 = "vpc-a-${random_string.this.id}"
  cidr                 = "10.1.0.0/16"
  azs                  = ["${local.region1}a", "${local.region1}b", "${local.region1}c"]
  public_subnets       = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnets      = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "fqdn-fw-test"
  }
} */

/* # Create an AWS VPC via Aviatrix
resource "aviatrix_vpc" "aws_vpc" {
  cloud_type           = 1
  account_name         = var.aws_account
  region               = local.region1
  name                 = "avxvpc-a-${random_string.this.id}"
  cidr                 = "10.1.0.0/16"
  subnet_size = 24
  num_of_subnet_pairs = 6
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
} */