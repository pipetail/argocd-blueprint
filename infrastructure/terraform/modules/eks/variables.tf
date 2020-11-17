variable "name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.17"
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "worker_groups_launch_template" {
  type = any
}

variable "worker_ami_name_filter" {
  type = string
}

variable "thumbprints" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "traefik_http_port" {
  type    = number
  default = 30080
}

variable "traefik_https_port" {
  type    = number
  default = 30443
}

variable "traefik_admin_port" {
  type    = number
  default = 30081
}

variable "cluster_enabled_log_types" {
  type = list(string)
  default = [
    "authenticator",
    "api",
  ]
}

variable "map_roles" {
  type = any
}

variable "workers_additional_policies" {
  type    = list(string)
  default = []
}