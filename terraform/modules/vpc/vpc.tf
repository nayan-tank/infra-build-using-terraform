########## Networking #############

resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
 
 tags = {
   Name = "${var.basename}-vpc"
 }
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "${var.basename}-igw"
 }
}

# EIPs
resource "aws_eip" "eip_ngw" {
  domain   = "vpc"
  # count = 3
}


resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.eip_ngw.id
    subnet_id = aws_subnet.public_subnet["public-2"].id
    
    tags = {
      Name = "${var.basename}-natgateway"
    }

    depends_on = [ aws_eip.eip_ngw ]
}


resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_list
 
  availability_zone = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-subnet-${each.key}"
  }
}


resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_list
 
  availability_zone = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-subnet-${each.key}"
  }
}




# ROUTE TABLES FOR PUBLIC SUBNETS
resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.main.id
    count = 3

    route {
        cidr_block = var.route_cidr
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "${var.basename}-rwt"
    }
}


# ROUTE TABLES FOR PRIVATE SUBNETS
resource "aws_route_table" "pvt_rt" {
    vpc_id = aws_vpc.main.id
    count = 3

    route {
        cidr_block = var.route_cidr
        gateway_id = aws_nat_gateway.ngw.id
    }

    tags = {
      Name = "${var.basename}-private-rwt"
    }
}


# ROUTE TABLE ASSOCIATIONS 

# PUBLIC
resource "aws_route_table_association" "public_subnets_asso" {
  for_each = var.public_subnet_list
  subnet_id = aws_subnet.public_subnet[each.key].id 
  route_table_id = aws_route_table.pub_rt[each.value.index].id

}

# PRIVATE
resource "aws_route_table_association" "private_subnets_asso" {
  for_each = var.private_subnet_list
  subnet_id = aws_subnet.private_subnet[each.key].id 
  route_table_id = aws_route_table.pvt_rt[each.value.index].id

}


resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
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

# resource "aws_instance" "ec2_instance" {
#   ami = var.ec2_config["ami"]
#   instance_type = var.ec2_config["inst_type"]
#   key_name = var.ec2_config["key"]
#   availability_zone = var.ec2_config["az"]
#   subnet_id = aws_subnet.public_subnet["public-2"].id
#   security_groups = [ aws_security_group.sg.id ] 

#   tags = {
#     Name = "Bastion Host"
#   }

# }

# resource "aws_elb" "ebl-1" {
#   name               = "${var.basename}-elb-1"
#   availability_zones = var.azs

#   listener {
#     instance_port     = 8000
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }

#   listener {
#     instance_port      = 8000
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 30
#   }

#   instances                   = [ aws_instance.ec2_instance.id ]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "${var.basename}-elb-1"
#   }

# }