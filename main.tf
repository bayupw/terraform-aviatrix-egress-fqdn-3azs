data "aws_region" "current" {}

# Create 3 digit random string
resource "random_string" "this" {
  length  = 3
  number  = true
  special = false
  upper   = false
}

# Create VPCs, subnets, route tables
module "vpc_a" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 3.0"
  name                 = "vpc-a-${random_string.this.id}"
  cidr                 = "10.0.0.0/16"
  azs                  = ["${local.region1}a", "${local.region1}b", "${local.region1}c","${local.region1}d","${local.region1}e","${local.region1}f"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  private_subnets      = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24", "10.0.15.0/24", "10.0.16.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "fqdn-fw-test"
  }
}

# Create FQDN Gateway
resource "aviatrix_gateway" "fqdn_gw" {
  count = length(module.vpc_a.public_subnets_cidr_blocks)

  cloud_type   = 1
  account_name = var.aws_account
  gw_name      = "fqdn-gw-${count.index}"
  vpc_id       = module.vpc_a.vpc_id
  vpc_reg      = local.region1
  gw_size      = "t2.micro"
  subnet       = module.vpc_a.public_subnets_cidr_blocks[count.index]
  #peering_ha_gw_size = "t3.micro"
  #peering_ha_subnet  = module.vpc_a.public_subnets_cidr_blocks[1]
  single_ip_snat = true

  tags = {
    name = "fqdn-gw-${count.index}"
  }

  depends_on = [module.vpc_a]
}

/* # Create FQDN Gateway
resource "aviatrix_gateway" "avx_fqdn_gw_a" {
  cloud_type   = 1
  account_name = var.aws_account
  gw_name      = "avx-fqdn-a"
  vpc_id       = aviatrix_vpc.aws_vpc.vpc_id
  vpc_reg      = local.region1
  gw_size      = "t2.micro"
  subnet       = aviatrix_vpc.aws_vpc.public_subnets[0].cidr
  #peering_ha_gw_size = "t2.micro"
  #peering_ha_subnet  = module.vpc_a.public_subnets_cidr_blocks[1]
  single_ip_snat = true

  tags = {
    name = "avx-fqdn-a"
  }
} */

/* resource "aviatrix_fqdn" "whitelist_filter" {
  fqdn_tag     = "whitelist_tag"
  fqdn_enabled = true
  fqdn_mode    = "white"

  gw_filter_tag_list {
    gw_name = aviatrix_gateway.fqdn_gw_a.gw_name
  }

  depends_on = [aviatrix_gateway.fqdn_gw_a]
}

resource "aviatrix_fqdn_tag_rule" "rules" {
  for_each = var.fqdn_rules

  fqdn_tag_name = aviatrix_fqdn.whitelist_filter.fqdn_tag
  fqdn          = split(",", each.value)[0]
  protocol      = split(",", each.value)[1]
  port          = split(",", each.value)[2]
  action        = try(split(",", each.value)[3], "Base Policy")

  depends_on = [aviatrix_fqdn.whitelist_filter]
} */