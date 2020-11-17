variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "env" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type = string
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "enable_s3_endpoint" {
  type    = bool
  default = true
}
