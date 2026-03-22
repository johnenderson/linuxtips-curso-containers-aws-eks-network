# linuxtips-curso-containers-aws-eks-network
Centralização da criação de recursos da Networking do módulo EKS

## Visão geral
Este repositório automátiza a infraestrutura de rede para um cluster EKS via Terraform. Inclui:
- VPC
- Subnets públicas, privadas e de banco (database)
- Internet Gateway
- Route Tables
- NAT Gateway
- SSM Parameter Store para IDs de VPC e subnets

## Estrutura de arquivos
- `providers.tf`: provedor AWS (root)
- `main.tf`: chamada do módulo `modules/networking`
- `variables.tf`: entrada de variáveis do root
- `outputs.tf`: exposições de outputs do módulo
- `modules/networking/`: implementação do módulo de rede
- `environment/prod/terraform.tfvars`: variáveis para ambiente de produção

## Módulo: modules/networking
O código principal foi movido para um módulo reutilizável em `modules/networking` com:
- `main.tf`: recursos (VPC, subnets, Nat, NACL, SG, SSM)
- `variables.tf`: parametrização rica
- `outputs.tf`: valores para consumo do root


## Exigências
- Terraform >= 1.0
- AWS CLI configurada (`aws configure`)
- Credenciais AWS com permissão de criar VPC, Subnets, IGW, NAT, etc.

## Inicialização e deploy
1. `terraform init` (pasta raiz)
2. `terraform plan -var-file=environment/prod/terraform.tfvars`
3. `terraform apply --auto-approve -var-file=environment/prod/terraform.tfvars`
4. `terraform destroy -var-file=environment/prod/terraform.tfvars` (quando precisar destruir)

## Variáveis principais
- `project_name`: prefixo para objetos e nome no Parameter Store
- `cidr_vpc`: CIDR da VPC (ex: `10.0.0.0/16`)
- `public_subnets`, `private_subnets`, `database_subnets`: listas de objetos com `name`, `cidr`, `availability_zone`

## Exemplo de `terraform.tfvars` (prod)
```hcl
project_name = "linuxtips"

cidr_vpc = "10.0.0.0/16"

public_subnets = [
  { name = "public-a" availability_zone = "eu-west-1a" cidr = "10.0.1.0/24" },
  { name = "public-b" availability_zone = "eu-west-1b" cidr = "10.0.2.0/24" },
]

private_subnets = [
  { name = "private-a" availability_zone = "eu-west-1a" cidr = "10.0.11.0/24" },
  { name = "private-b" availability_zone = "eu-west-1b" cidr = "10.0.12.0/24" },
]

database_subnets = [
  { name = "db-a" availability_zone = "eu-west-1a" cidr = "10.0.21.0/24" },
  { name = "db-b" availability_zone = "eu-west-1b" cidr = "10.0.22.0/24" },
]
```

## Uso do módulo
```hcl
module "networking" {
  source              = "./modules/networking"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  vpc_additional_cidrs = var.vpc_additional_cidrs
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets

  tags = {
    Environment = "prod"
    Owner       = "platform"
  }

  security_group_rules = [
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["10.0.0.0/8"]
      description = "Allow SSH from workplace"
    }
  ]
}
```

## Terraform docs
1. Instale o terraform-docs: `brew install terraform-docs` ou `choco install terraform-docs`
2. Gere documentação:
   `terraform-docs markdown modules/networking >> README.md`

## Visualização da arquitetura
```mermaid
flowchart LR
  A[VPC] --> B[Public Subnets]
  A --> C[Private Subnets]
  A --> D[Database Subnets]
  B --> E[IGW]
  C --> F[NAT Gateway]
  D --> G["Network ACL (DB)"]
  A --> H["Default SG"]
```

## Observações
- O recurso `aws_ssm_parameter` utiliza `count` para cada lista de subnets. Certifique-se de que `count = length(var.public_subnets)` (e equivalentes) esteja presente antes de usar `count.index`.
- Se você receber `Reference to "count" in non-counted context`, confirme que a declaração `count = ...` não foi removida.
