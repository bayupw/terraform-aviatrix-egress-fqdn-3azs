# # Retrieve my public IP address
# data "http" "my_public_ip" {
#   url = "http://ipv4.icanhazip.com"
# }

# module "ssm_instance_profile" {
#   source  = "bayupw/ssm-instance-profile/aws"
#   version = "1.0.0"
# }

# module "ssm_vpce_vpc_a" {
#   count = length(module.vpc_a.private_subnets)

#   source  = "bayupw/ssm-vpc-endpoint/aws"
#   version = "1.0.1"

#   vpc_id         = module.vpc_a.vpc_id
#   vpc_subnet_ids = [module.vpc_a.private_subnets[count.index]]
#   private_dns_enabled = count.index == 0 ? true : false 

#   depends_on = [module.vpc_a]
# }

# module "instance_a" {
#   count = length(module.vpc_a.private_subnets)
  
#   source  = "bayupw/amazon-linux-2/aws"
#   version = "1.0.0"

#   random_suffix               = false
#   instance_hostname           = "instance-${count.index}-${random_string.this.id}"
#   instance_type               = "t2.micro"
#   vpc_id                      = module.vpc_a.vpc_id
#   subnet_id                   = module.vpc_a.private_subnets[count.index]
#   iam_instance_profile        = module.ssm_instance_profile.aws_iam_instance_profile
#   associate_public_ip_address = false

#   depends_on = [module.vpc_a, module.ssm_instance_profile]
# }