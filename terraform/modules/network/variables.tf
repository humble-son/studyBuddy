variable "vpc_tag_name" {
    description = "The name of my vpc"
    type = string
    default = "studybuddy_vpc_prod"
}

variable "internet_gateway_name" {
    type = string
    description = "The tag name for the internet gateway"
    default = "studybuddy_igw_prod"
}

variable "public_route_table_name" {
  type = string
  description = "The tag name for the public route table"
  default = "studybuddy_public_rtb_prod"
}

variable "aws_elastic_ip_vpc_domain" {
  type = string
  description = "This sets the domain of the elastic IP address to vpc"
  default = "vpc"
}

variable "aws_nat_gateway_tag" {
  type = string
  default = "studybuddy_nat_gateway_prod"
}

variable "private_route_table_name" {
  type = string
  default = "studybuddy_private_rtb_prod"
}

variable "all_cidr" {
  type = string
  default = "0.0.0.0/0"
}