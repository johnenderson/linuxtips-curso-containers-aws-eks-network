## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_rule.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.database_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_ipv4_cidr_block_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_default_sg"></a> [create\_default\_sg](#input\_create\_default\_sg) | Criar um security group padrão para a VPC | `bool` | `false` | no |
| <a name="input_database_nacl_rules"></a> [database\_nacl\_rules](#input\_database\_nacl\_rules) | Regras de NACL de database | <pre>list(object({<br/>    rule_number = number<br/>    egress      = bool<br/>    protocol    = string<br/>    rule_action = string<br/>    cidr_block  = string<br/>    from_port   = number<br/>    to_port     = number<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_block": "10.0.0.0/8",<br/>    "egress": false,<br/>    "from_port": 3306,<br/>    "protocol": "tcp",<br/>    "rule_action": "allow",<br/>    "rule_number": 100,<br/>    "to_port": 3306<br/>  },<br/>  {<br/>    "cidr_block": "10.0.0.0/8",<br/>    "egress": false,<br/>    "from_port": 6379,<br/>    "protocol": "tcp",<br/>    "rule_action": "allow",<br/>    "rule_number": 110,<br/>    "to_port": 6379<br/>  },<br/>  {<br/>    "cidr_block": "0.0.0.0/0",<br/>    "egress": true,<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_action": "allow",<br/>    "rule_number": 200,<br/>    "to_port": 0<br/>  },<br/>  {<br/>    "cidr_block": "0.0.0.0/0",<br/>    "egress": false,<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "rule_action": "deny",<br/>    "rule_number": 300,<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_database_subnet_tags"></a> [database\_subnet\_tags](#input\_database\_subnet\_tags) | Tags adicionais para subnets de database | `map(string)` | `{}` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | Lista de subnets de banco de dados | <pre>list(object({<br/>    name              = string<br/>    cidr              = string<br/>    availability_zone = string<br/>  }))</pre> | `[]` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Habilitar criação de NAT Gateway para subnets privadas | `bool` | `true` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Tags adicionais para subnets privadas | `map(string)` | `{}` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Lista de subnets privadas | <pre>list(object({<br/>    name              = string<br/>    cidr              = string<br/>    availability_zone = string<br/>  }))</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nome do projeto, usado para tags e naming | `string` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Tags adicionais para subnets públicas | `map(string)` | `{}` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Lista de subnets públicas | <pre>list(object({<br/>    name              = string<br/>    cidr              = string<br/>    availability_zone = string<br/>  }))</pre> | n/a | yes |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Regras de Security Group adicionais a aplicar | <pre>list(object({<br/>    type        = string<br/>    protocol    = string<br/>    from_port   = number<br/>    to_port     = number<br/>    cidr_blocks = list(string)<br/>    description = string<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags globais que serão aplicadas a todos os recursos | `map(string)` | `{}` | no |
| <a name="input_vpc_additional_cidrs"></a> [vpc\_additional\_cidrs](#input\_vpc\_additional\_cidrs) | CIDRs adicionais a serem associados à VPC. | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR principal da VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | n/a |
| <a name="output_network_acl_id"></a> [network\_acl\_id](#output\_network\_acl\_id) | n/a |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | n/a |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | n/a |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |
| <a name="output_ssm_parameter_ids"></a> [ssm\_parameter\_ids](#output\_ssm\_parameter\_ids) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
