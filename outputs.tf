output "vpc_id" {
  value = aws_ssm_parameter.vpc.id
}

output "public_subnet_ids" {
  value = aws_ssm_parameter.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_ssm_parameter.private_subnets[*].id
}

output "database_subnet_ids" {
  value = aws_ssm_parameter.database_subnets[*].id
}