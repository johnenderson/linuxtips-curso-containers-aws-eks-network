output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "network_acl_id" {
  value = aws_network_acl.database.id
}

output "security_group_id" {
  value = try(aws_security_group.default[0].id, null)
}

output "ssm_parameter_ids" {
  value = {
    vpc      = aws_ssm_parameter.vpc.id
    public   = aws_ssm_parameter.public_subnets[*].id
    private  = aws_ssm_parameter.private_subnets[*].id
    database = aws_ssm_parameter.database_subnets[*].id
  }
}
