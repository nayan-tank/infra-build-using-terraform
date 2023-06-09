####### AWS 
aws_region = "us-east-2"

###### VPC
vpc_cidr = "10.1.0.0/16"

basename = "dev"

route_cidr = "0.0.0.0/0"

public_subnet_list = {
    public-1 = {
        index = 0
        az = "us-east-2a"
        cidr = "10.1.1.0/24"
    }
    public-2 = {
        index = 1
        az = "us-east-2b"
        cidr = "10.1.2.0/24"
    }
    public-3 = {
        index = 2
        az = "us-east-2c"
        cidr = "10.1.3.0/24"
    }
}

private_subnet_list = {
    private-1 = {
        index = 0
        az = "us-east-2a"
        cidr = "10.1.4.0/24"
    }
    private-2 = {
        index = 1
        az = "us-east-2b"
        cidr = "10.1.5.0/24"
    }
    private-3 = {
        index = 2
        az = "us-east-2c"
        cidr = "10.1.6.0/24"
    }
}

eks_node_volume_size = 200
eks_node_volume_type = "gp3"


cluster_name       = "cluster"
cluster_version    = "1.27"

eks_node_ami_type = "AL2_x86_64"
eks_node_disk_size              = 200
eks_node_instance_type          =  ["t2.medium"]
eks_node_instance_capacity_type = "ON_DEMAND"

eks_node_minimum_number  = 3
eks_node_maximum_number  = 3

cluster_endpoint_private_access = true
cluster_endpoint_public_access = false