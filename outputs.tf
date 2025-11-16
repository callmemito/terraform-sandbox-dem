output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.test_network.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.test_network.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.test_network.id
}

output "s3_vpc_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}
