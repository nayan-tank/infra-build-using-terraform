
# AWS LAUNCH TEMPLATE FOR EKS NODE
resource "aws_launch_template" "external" {
  name_prefix            = "external-"
  description            = "EKS managed node group external launch template"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.eks_node_volume_size
      volume_type           = var.eks_node_volume_type
      # iops                  = 3000
      # throughput            = 125
      # encrypted             = false
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "eks-on-demand"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name      = "eks-on-demand"
    }
  }

  tags = {
    environment = "dev-env"
  }

  lifecycle {
    create_before_destroy = true
  }
}




# EKS NODE SECURITY GROUP
resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.main.cidr_block]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.basename}-sg"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.15.2"
  cluster_name                    = "${var.basename}-${var.cluster_name}"
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  vpc_id     = module.vpc.vpc_id
  subnet_ids = [ module.vpc.private_subnet_0.id, module.vpc.private_subnet_1.id,module.vpc.private_subnet_2.id, ] 

  cluster_addons = {
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = var.eks_node_ami_type
    disk_size              = var.eks_node_disk_size
    instance_types         = var.eks_node_instance_type
    capacity_type          = "ON_DEMAND"
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "VPC API Access"
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      cidr_blocks                 = [ module.vpc.vpc_cidr ]
    }
  }
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_groups = {
    on-demand = {
      create_launch_template   = false
      launch_template_name     = aws_launch_template.external.name
      launch_template_version  = aws_launch_template.external.default_version
      min_size                 = var.eks_node_minimum_number 
      max_size                 = var.eks_node_maximum_number 
      desired_size             = var.eks_node_minimum_number 

      capacity_type  = var.eks_node_instance_capacity_type
      
      tags = {
        environment = "dev"
      }
    }
  }
}