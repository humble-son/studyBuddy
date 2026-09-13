output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.dev_vpc.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = aws_vpc.dev_vpc.tags["Name"]
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.dev_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_names" {
  description = "Names of all public subnets"
  value       = aws_subnet.public[*].tags["Name"]
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of all public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_availability_zones" {
  description = "Availability Zones of all public subnets"
  value       = aws_subnet.public[*].availability_zone
}

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_names" {
  description = "Names of all private subnets"
  value       = aws_subnet.private[*].tags["Name"]
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of all private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnet_availability_zones" {
  description = "Availability Zones of all private subnets"
  value       = aws_subnet.private[*].availability_zone
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "internet_gateway_name" {
  description = "Name of the Internet Gateway"
  value       = aws_internet_gateway.igw.tags["Name"]
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "public_route_table_name" {
  description = "Name of the public route table"
  value       = aws_route_table.public.tags["Name"]
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "private_route_table_name" {
  description = "Name of the private route table"
  value       = aws_route_table.private.tags["Name"]
}

output "nat_eip_id" {
  description = "Allocation ID of the NAT Gateway Elastic IP"
  value       = aws_eip.nat.id
}

output "nat_eip_public_ip" {
  description = "Public IP address assigned to the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  value       = aws_nat_gateway.nat.tags["Name"]
}

output "nat_gateway_subnet_id" {
  description = "ID of the public subnet containing the NAT Gateway"
  value       = aws_nat_gateway.nat.subnet_id
}

output "network_summary" {
  description = "Summary of the network infrastructure"
  value = {
    vpc = {
      id   = aws_vpc.dev_vpc.id
      name = aws_vpc.dev_vpc.tags["Name"]
      cidr = aws_vpc.dev_vpc.cidr_block
    }

    public_subnets = [
      for subnet in aws_subnet.public : {
        id   = subnet.id
        name = subnet.tags["Name"]
        cidr = subnet.cidr_block
        az   = subnet.availability_zone
      }
    ]

    private_subnets = [
      for subnet in aws_subnet.private : {
        id   = subnet.id
        name = subnet.tags["Name"]
        cidr = subnet.cidr_block
        az   = subnet.availability_zone
      }
    ]

    internet_gateway = {
      id   = aws_internet_gateway.igw.id
      name = aws_internet_gateway.igw.tags["Name"]
    }

    nat_gateway = {
      id        = aws_nat_gateway.nat.id
      name      = aws_nat_gateway.nat.tags["Name"]
      public_ip = aws_eip.nat.public_ip
    }
  }
}
