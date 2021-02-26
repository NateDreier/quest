variable "profile" {
  type    = string
  default = "default"
}
variable "region-east-primary" {
  type    = string
  default = "us-east-1"
}
variable "external_ips" {
  type    = string
  default = "0.0.0.0/0"
}
variable "dns-name" {
  type    = string
  default = "natethegr8.net."
}
variable "subnet_east_1" {
  type    = string
  default = "10.0.1.0/24"
}
variable "subnet_east_2" {
  type    = string
  default = "10.0.2.0/24"
}
variable "ecr_repository_name" {
  type    = string
  default = "quest_repository"
}
