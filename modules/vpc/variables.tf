variable "profile" {
  type    = string
  default = "default"
}
variable "region-east-primary" {
  type    = string
  default = "us-east-1"
}
variable "vpc_east_subnet" {
  type    = string
  default = "10.0.0.0/16"
}
variable "subnet_east_1" {
  description = "subnet for subnet_east_1"
  type        = string
}
variable "subnet_east_2" {
  description = "subnet for subnet_east_2"
  type        = string
}
variable "external_ips" {
  description = "allowed IPs from external"
  type        = string
}