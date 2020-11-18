variable "env" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "http_allow_cidrs" {
  type = list(string)
}

variable "https_allow_cidrs" {
  type = list(string)
}

variable "traefik_healthcheck_path" {
  type    = string
  default = "/ping"
}

variable "traefik_healthcheck_port" {
  type    = number
  default = 30081
}

variable "traefik_healthcheck_protocol" {
  type    = string
  default = "HTTP"
}

variable "traefik_http_port" {
  type    = number
  default = 30080
}

variable "traefik_https_port" {
  type    = number
  default = 30443
}

variable "subnets" {
  type = list(string)
}

variable "listener_http_port" {
  type    = number
  default = 80
}

variable "listener_https_port" {
  type    = number
  default = 443
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  type = string
}

variable "additional_certificates_arns" {
  type    = list(string)
  default = []
}

variable "interval" {
  type    = number
  default = 10
}
