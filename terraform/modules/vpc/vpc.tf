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

resource "aws_subnet" "main-subnet" {
  for_each = var.subnet_list
 
  availability_zone = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-subnet-${each.key}"
  }
}