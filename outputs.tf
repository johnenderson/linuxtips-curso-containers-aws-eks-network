output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.networking.database_subnet_ids
}

output "network_acl_id" {
  value = module.networking.network_acl_id
}

output "security_group_id" {
  value = module.networking.security_group_id
}

output "ssm_parameter_ids" {
  value = module.networking.ssm_parameter_ids
}
