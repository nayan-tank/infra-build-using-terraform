output "vpc_id" {
    value = aws_vpc.main.id
}

output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}


output "subnet_ids_list" {
  value = [ aws_subnet.private_subnet["private-1"].id , aws_subnet.private_subnet["private-2"].id , aws_subnet.private_subnet["private-3"].id ]
}