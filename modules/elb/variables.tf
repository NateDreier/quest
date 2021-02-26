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
variable "external_ips" {
  description = "allowed IPs from external"
  type        = string
}
variable "vpc_east_primary_id" {
  type        = string
  description = "VPC east primary id"
}
variable "dns-name" {
  type        = string
  description = "Primary DNS"
}
variable "subnet_east_1_id" {
  type        = string
  description = "subnet east 1 id"
}
variable "subnet_east_2_id" {
  type        = string
  description = "subnet east 2 id"
}