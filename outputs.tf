output "vpc_id" {
  description = "ID da VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs das subnets públicas"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "IDs das subnets privadas"
  value       = module.vpc.private_subnets
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "default_sg" {
  description = "Default Security Group da VPC"
  value       = module.vpc.default_security_group_id
}


output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.user_pool.arn
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "user_pool_client_secret" {
  value = aws_cognito_user_pool_client.user_pool_client.client_secret
  sensitive = true
}

output "sqs_notificar_falha_url" {
  value = aws_sqs_queue.sqs_notificar_falha.url
}

output "sqs_processar_video_url" {
  value = aws_sqs_queue.sqs_processar_video.url
}