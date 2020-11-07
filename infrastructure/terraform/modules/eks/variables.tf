variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.18"
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

variable "workers_additional_policies" {
  type    = list(string)
  default = []
}

variable "map_users" {
  type    = any
  default = []
}

variable "map_roles" {
  type    = any
  default = []
}

variable "thumbprints" {
  type    = list(string)
  default = []
}

variable "wait_for_cluster_cmd" {
  type    = string
  default = null
}

variable "wait_for_cluster_interpreter" {
  type    = list(string)
  default = null
}