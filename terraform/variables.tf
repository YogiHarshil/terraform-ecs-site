# Cloud Provider Configuration
variable "cloud_provider" {
  description = "Cloud provider to use (aws, azure, gcp)"
  type        = string
  default     = "aws"
  
  validation {
    condition     = contains(["aws", "azure", "gcp"], var.cloud_provider)
    error_message = "Cloud provider must be one of: aws, azure, gcp."
  }
}

# Project Configuration
variable "project_name" {
  description = "Name of the project (used for resource naming)"
  type        = string
  default     = "nextjs-ecs"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# AWS Configuration
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "aws_availability_zones" {
  description = "AWS availability zones to use (leave empty for auto-selection)"
  type        = list(string)
  default     = []
}

# Azure Configuration
variable "azure_location" {
  description = "Azure location for deployment"
  type        = string
  default     = "East US"
}

variable "azure_resource_group" {
  description = "Azure resource group name (leave empty for auto-generated)"
  type        = string
  default     = ""
}

# GCP Configuration
variable "gcp_project" {
  description = "GCP project ID for deployment"
  type        = string
  default     = ""
}

variable "gcp_region" {
  description = "GCP region for deployment"
  type        = string
  default     = "us-central1"
}

# GitHub OIDC Configuration
variable "github_repository" {
  description = "GitHub repository in format 'owner/repo' for OIDC authentication"
  type        = string
  default     = "your-username/terraform-ecs-site"
}

variable "github_branch" {
  description = "GitHub branch allowed for OIDC authentication"
  type        = string
  default     = "main"
}

# Container Configuration
variable "desired_count" {
  description = "Desired number of container instances to run"
  type        = number
  default     = 1
  
  validation {
    condition     = var.desired_count >= 1 && var.desired_count <= 10
    error_message = "Desired count must be between 1 and 10."
  }
}

variable "cpu" {
  description = "CPU units for container (256 = 0.25 vCPU)"
  type        = string
  default     = "256"
  
  validation {
    condition     = contains(["256", "512", "1024", "2048", "4096"], var.cpu)
    error_message = "CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "memory" {
  description = "Memory in MiB for container"
  type        = string
  default     = "512"
  
  validation {
    condition     = contains(["512", "1024", "2048", "3072", "4096", "5120", "6144", "7168", "8192"], var.memory)
    error_message = "Memory must be compatible with CPU allocation."
  }
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC (AWS) or Virtual Network (Azure/GCP)"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.vpc_cidr))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway/Instance for private subnets (disable for cost optimization in dev)"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway/Instance instead of one per AZ (cost optimization)"
  type        = bool
  default     = true
}

# Application Configuration
variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/api/health"
}

# Monitoring Configuration
variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 3
  
  validation {
    condition     = var.log_retention_days >= 1 && var.log_retention_days <= 3653
    error_message = "Log retention days must be between 1 and 3653."
  }
}

# Scaling Configuration
variable "enable_auto_scaling" {
  description = "Enable auto scaling for container service"
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "Minimum number of instances for auto scaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of instances for auto scaling"
  type        = number
  default     = 3
}

variable "cpu_target_value" {
  description = "Target CPU utilization for auto scaling"
  type        = number
  default     = 70
} 