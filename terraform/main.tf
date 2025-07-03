# Multi-Cloud Next.js Deployment with Terraform

# Random suffix for unique naming across cloud providers
resource "random_id" "suffix" {
  byte_length = 4
}

# AWS Deployment (ECS Fargate)
module "aws_ecs" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  source = "./modules/aws-ecs"
  
  # Core configuration
  aws_region         = var.aws_region
  environment        = var.environment
  resource_prefix    = local.resource_prefix
  common_tags        = local.common_tags
  availability_zones = local.availability_zones
  
  # Network configuration
  vpc_cidr           = var.vpc_cidr
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  
  # Container configuration
  cpu            = var.cpu
  memory         = var.memory
  desired_count  = var.desired_count
  container_port = var.container_port
  
  # Application configuration
  health_check_path = var.health_check_path
  
  # Monitoring
  log_retention_days = var.log_retention_days
  
  # Scaling
  enable_auto_scaling = var.enable_auto_scaling
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  cpu_target_value   = var.cpu_target_value
}

# Azure Deployment (Container Apps)
module "azure_container_apps" {
  count  = var.cloud_provider == "azure" ? 1 : 0
  source = "./modules/azure-container-apps"
  
  # Core configuration
  location        = var.azure_location
  environment     = var.environment
  resource_prefix = local.resource_prefix
  common_tags     = local.common_tags
  
  # Resource group
  resource_group_name = var.azure_resource_group != "" ? var.azure_resource_group : "${local.resource_prefix}-rg"
  
  # Container configuration
  cpu           = var.cpu
  memory        = var.memory
  desired_count = var.desired_count
  container_port = var.container_port
  
  # Application configuration
  health_check_path = var.health_check_path
  
  # Monitoring
  log_retention_days = var.log_retention_days
  
  # Scaling
  enable_auto_scaling = var.enable_auto_scaling
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  cpu_target_value   = var.cpu_target_value
}

# GCP Deployment (Cloud Run)
module "gcp_cloud_run" {
  count  = var.cloud_provider == "gcp" ? 1 : 0
  source = "./modules/gcp-cloud-run"
  
  # Core configuration
  project_id      = var.gcp_project
  region          = var.gcp_region
  environment     = var.environment
  resource_prefix = local.resource_prefix
  common_labels   = local.common_tags
  
  # Container configuration
  cpu           = var.cpu
  memory        = var.memory
  desired_count = var.desired_count
  container_port = var.container_port
  
  # Application configuration
  health_check_path = var.health_check_path
  
  # Monitoring
  log_retention_days = var.log_retention_days
  
  # Scaling
  enable_auto_scaling = var.enable_auto_scaling
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  cpu_target_value   = var.cpu_target_value
}

# Note: OIDC configuration is in oidc.tf

# Multi-cloud deployment outputs
locals {
  deployment_outputs = var.cloud_provider == "aws" ? {
    application_url    = module.aws_ecs[0].application_url
    health_check_url   = module.aws_ecs[0].health_check_url
    container_registry = module.aws_ecs[0].ecr_repository_url
    cluster_name      = module.aws_ecs[0].ecs_cluster_name
    service_name      = module.aws_ecs[0].ecs_service_name
    load_balancer_dns = module.aws_ecs[0].load_balancer_dns
    logs_group        = module.aws_ecs[0].cloudwatch_log_group_name
    oidc_role_arn     = var.cloud_provider == "aws" ? aws_iam_role.github_actions[0].arn : null
  } : var.cloud_provider == "azure" ? {
    application_url    = module.azure_container_apps[0].application_url
    health_check_url   = module.azure_container_apps[0].health_check_url
    container_registry = module.azure_container_apps[0].container_registry_url
    cluster_name      = module.azure_container_apps[0].container_app_environment_name
    service_name      = module.azure_container_apps[0].container_app_name
    load_balancer_dns = module.azure_container_apps[0].application_url
    logs_group        = module.azure_container_apps[0].log_analytics_workspace_name
    oidc_role_arn     = null # Azure uses service principal authentication
  } : var.cloud_provider == "gcp" ? {
    application_url    = module.gcp_cloud_run[0].application_url
    health_check_url   = module.gcp_cloud_run[0].health_check_url
    container_registry = module.gcp_cloud_run[0].container_registry_url
    cluster_name      = "cloud-run"
    service_name      = module.gcp_cloud_run[0].service_name
    load_balancer_dns = module.gcp_cloud_run[0].application_url
    logs_group        = module.gcp_cloud_run[0].log_sink_name
    oidc_role_arn     = null # GCP uses workload identity
  } : {
    application_url    = "No deployment configured"
    health_check_url   = "No deployment configured"
    container_registry = "No deployment configured"
    cluster_name      = "No deployment configured"
    service_name      = "No deployment configured"
    load_balancer_dns = "No deployment configured"
    logs_group        = "No deployment configured"
    oidc_role_arn     = null
  }
}

# Note: Terraform configuration, providers, and data sources moved to providers.tf
# All provider configurations and data sources are now centralized to avoid duplication 