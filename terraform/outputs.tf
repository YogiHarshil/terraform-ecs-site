# Multi-Cloud Terraform Outputs

# Application Information
output "cloud_provider" {
  description = "Selected cloud provider"
  value       = var.cloud_provider
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "resolved_region" {
  description = "Resolved deployment region"
  value       = local.resolved_region
}

# Application URLs
output "application_url" {
  description = "Main application URL"
  value       = local.deployment_outputs.application_url
}

output "health_check_url" {
  description = "Health check endpoint URL"
  value       = local.deployment_outputs.health_check_url
}

# Infrastructure Resources
output "container_registry" {
  description = "Container registry URL"
  value       = local.deployment_outputs.container_registry
}

output "cluster_name" {
  description = "Container cluster/service name"
  value       = local.deployment_outputs.cluster_name
}

output "service_name" {
  description = "Container service name"
  value       = local.deployment_outputs.service_name
}

output "load_balancer_dns" {
  description = "Load balancer DNS name"
  value       = local.deployment_outputs.load_balancer_dns
}

output "logs_group" {
  description = "Logs group/workspace name"
  value       = local.deployment_outputs.logs_group
}

# GitHub Actions Information
output "github_actions_role_arn" {
  description = "GitHub Actions OIDC role ARN (AWS only)"
  value       = local.deployment_outputs.oidc_role_arn
  sensitive   = false
}

output "github_repository" {
  description = "GitHub repository configured for OIDC"
  value       = var.github_repository
}

output "github_branch" {
  description = "GitHub branch configured for OIDC"
  value       = var.github_branch
}

# Deployment Summary
output "deployment_summary" {
  description = "Complete deployment information"
  value = {
    cloud_provider = var.cloud_provider
    environment   = var.environment
    region        = local.resolved_region
    
    # Application
    application_url   = local.deployment_outputs.application_url
    health_check_url  = local.deployment_outputs.health_check_url
    
    # Infrastructure
    container_registry = local.deployment_outputs.container_registry
    cluster_name      = local.deployment_outputs.cluster_name
    service_name      = local.deployment_outputs.service_name
    logs_group        = local.deployment_outputs.logs_group
    
    # GitHub Actions
    github_repository = var.github_repository
    github_branch     = var.github_branch
    oidc_role_arn     = local.deployment_outputs.oidc_role_arn
    
    # Configuration
    container_config = {
      cpu           = var.cpu
      memory        = var.memory
      desired_count = var.desired_count
      auto_scaling  = var.enable_auto_scaling
    }
    
    # Cost optimization
    cost_optimizations = {
      environment        = var.environment
      nat_gateway        = var.enable_nat_gateway
      single_nat         = var.single_nat_gateway
      log_retention_days = var.log_retention_days
    }
  }
}

# Setup Instructions
output "next_steps" {
  description = "Next steps for deployment"
  value = <<-EOT
    
    ✅ Terraform deployment complete!
    
    🌍 Cloud Provider: ${upper(var.cloud_provider)}
    🏗️  Environment: ${var.environment}
    📍 Region: ${local.resolved_region}
    
    📋 Next Steps:
    1. Update GitHub repository secrets:
       - AWS_ROLE_ARN: ${local.deployment_outputs.oidc_role_arn != null ? local.deployment_outputs.oidc_role_arn : "N/A (manual setup required)"}
       - AWS_REGION: ${var.cloud_provider == "aws" ? var.aws_region : "N/A"}
    
    2. Push your code to trigger GitHub Actions:
       git push origin main
    
    3. Monitor deployment:
       - GitHub Actions: https://github.com/${var.github_repository}/actions
       - Application: ${local.deployment_outputs.application_url}
       - Health Check: ${local.deployment_outputs.health_check_url}
    
    📊 Infrastructure:
    - Container Registry: ${local.deployment_outputs.container_registry}
    - Service: ${local.deployment_outputs.service_name}
    - Logs: ${local.deployment_outputs.logs_group}
    
    🔧 Configuration:
    - CPU: ${var.cpu} units
    - Memory: ${var.memory}Mi
    - Replicas: ${var.desired_count}
    - Auto-scaling: ${var.enable_auto_scaling ? "enabled" : "disabled"}
    
    💰 Cost Optimization:
    - NAT Gateway: ${var.enable_nat_gateway ? "enabled" : "disabled (saves $32/month)"}
    - Log Retention: ${var.log_retention_days} days
    - Environment: ${var.environment} (cost-optimized)
    
  EOT
} 