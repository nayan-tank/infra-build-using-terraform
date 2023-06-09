module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    basename = var.basename
    public_subnet_list = var.public_subnet_list
    private_subnet_list = var.private_subnet_list
}

# module "eks" {
#   source = "./modules/eks"
#   subnet_ids = module.vpc.subnet_ids_list
#   vpc_id = module.vpc.vpc_id
#   cidr_block = var.vpc_cidr
#   basename = var.basename
#   eks_node_volume_size = var.eks_node_volume_size
#   eks_node_volume_type = var.eks_node_volume_type
#   cluster_name                    = "${var.basename}-${var.cluster_name}"
#   cluster_version                 = var.cluster_version
#   eks_node_disk_size = var.eks_node_disk_size
#   eks_node_ami_type = var.eks_node_ami_type
#   eks_node_instance_type = var.eks_node_instance_type
#   eks_node_instance_capacity_type = var.eks_node_instance_capacity_type
#   cluster_endpoint_public_access = var.cluster_endpoint_private_access
#   cluster_endpoint_private_access = var.cluster_endpoint_private_access
# }