variable "project_name" {
  description = "Nome do projeto, usado para tags e naming"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR principal da VPC."
  type        = string
}

variable "vpc_additional_cidrs" {
  description = "CIDRs adicionais a serem associados à VPC."
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "Lista de subnets públicas"
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "Lista de subnets privadas"
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}

variable "database_subnets" {
  description = "Lista de subnets de banco de dados"
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  default = []
}

variable "tags" {
  description = "Tags globais que serão aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Tags adicionais para subnets públicas"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Tags adicionais para subnets privadas"
  type        = map(string)
  default     = {}
}

variable "database_subnet_tags" {
  description = "Tags adicionais para subnets de database"
  type        = map(string)
  default     = {}
}

variable "enable_nat_gateway" {
  description = "Habilitar criação de NAT Gateway para subnets privadas"
  type        = bool
  default     = true
}

variable "create_default_sg" {
  description = "Criar um security group padrão para a VPC"
  type        = bool
  default     = false
}

variable "security_group_rules" {
  description = "Regras de Security Group adicionais a aplicar"
  type = list(object({
    type        = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "database_nacl_rules" {
  description = "Regras de NACL de database"
  type = list(object({
    rule_number = number
    egress      = bool
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = [
    {
      rule_number = 100
      egress      = false
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/8"
      from_port   = 3306
      to_port     = 3306
    },
    {
      rule_number = 110
      egress      = false
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/8"
      from_port   = 6379
      to_port     = 6379
    },
    {
      rule_number = 200
      egress      = true
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    },
    {
      rule_number = 300
      egress      = false
      protocol    = "-1"
      rule_action = "deny"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    }
  ]
}
