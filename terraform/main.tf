module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    basename = var.basename
    subnet_list = var.subnet_list
}