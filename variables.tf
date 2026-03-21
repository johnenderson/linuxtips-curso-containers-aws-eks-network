variable "project_name" {
  description = "Nome do projeto, utilizado para taguear os recursos."
  type        = string

}

variable "region" {
  description = "The region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR principal da VPC."
  type        = string
}

variable "vpc_additional_cidrs" {
  description = "Lista de CIDR`s adicionais para a VPC."
  type        = list(string)
  default     = []
}
