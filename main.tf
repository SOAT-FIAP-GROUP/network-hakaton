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

resource "aws_sqs_queue" "sqs_processar_video" {
  name                      = "sqs-processar-video"
  tags = local.tags
}

resource "aws_sqs_queue" "sqs_criar_status_processo" {
  name                      = "sqs-criar-status-processo"
  tags = local.tags
}

resource "aws_sqs_queue" "sqs_objeto_criado" {
  name                      = "sqs-objeto-criado"
  tags = local.tags
}

resource "aws_sqs_queue" "sqs_notificar_falha" {
  name                      = "sqs-notificar-falha"
  tags = local.tags
}