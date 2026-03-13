module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #   version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  # intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}


#=================================================
#                   SQS QUEUES
#=================================================
resource "aws_sqs_queue" "sqs_processar_video" {
  name = "sqs-processar-video"
  tags = local.tags
}

resource "aws_sqs_queue" "sqs_criar_status_processo" {
  name = "sqs-criar-status-processo"
  tags = local.tags
}

resource "aws_sqs_queue" "sqs_objeto_criado" {
  name = "sqs-objeto-criado"
  tags = local.tags
}

resource "aws_sqs_queue" "sqs_notificar_falha" {
  name = "sqs-notificar-falha"
  tags = local.tags
}


#=================================================
#               S3 UPLOADS/DOWNLOADS
#=================================================

resource "aws_s3_bucket" "my_bucket" {
  bucket = "948512815388" # nome único global

  tags = local.tags

}

#=================================================
#                     COGNITO
#=================================================

resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.project_name}-user-pool"

  username_attributes = ["email"]

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = false # optional
    mutable             = true
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_uppercase = false
    require_numbers   = false
    require_symbols   = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  lifecycle {
    ignore_changes = [schema]
  }

  # Remove username_attributes / alias_attributes
  tags = local.tags
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]

  generate_secret               = true
  prevent_user_existence_errors = "ENABLED"

  allowed_oauth_flows_user_pool_client = false
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "domain" {
  count        = var.enable_user_pool_domain ? 1 : 0
  domain       = var.user_pool_domain_prefix
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
