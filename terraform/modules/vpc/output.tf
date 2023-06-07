output "vpc_id" {
    value = aws_vpc.main.id
}

output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}

output "private_subnet_0" {
    value = aws_subnet.private_subnet["private-1"]
}
output "private_subnet_1" {
    value = aws_subnet.private_subnet["private-2"]
}
output "private_subnet_2" {
    value = aws_subnet.private_subnet["private-3"]
}