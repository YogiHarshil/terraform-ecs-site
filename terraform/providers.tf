# Multi-Cloud Terraform Configuration
terraform {
  required_version = ">= 1.5"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Uncomment and configure for remote state storage
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "terraform/state"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
  
  # Skip provider registration if not using AWS
  skip_region_validation      = var.cloud_provider != "aws"
  skip_credentials_validation = var.cloud_provider != "aws"
  skip_metadata_api_check     = var.cloud_provider != "aws"
  
  default_tags {
    tags = {
      Project       = var.project_name
      Environment   = var.environment
      CloudProvider = "AWS"
      ManagedBy     = "Terraform"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  
  # Skip provider registration if not using Azure
  skip_provider_registration = var.cloud_provider != "azure"
}

# Google Cloud Provider Configuration
provider "google" {
  project = var.cloud_provider == "gcp" ? var.gcp_project : null
  region  = var.gcp_region
  
  # Only configure if using GCP
  user_project_override = var.cloud_provider == "gcp"
}

# Random provider for generating unique names
provider "random" {}

# Local values for multi-cloud configuration
locals {
  # Common tags for all resources
  common_tags = {
    Project       = var.project_name
    Environment   = var.environment
    CloudProvider = title(var.cloud_provider)
    ManagedBy     = "Terraform"
    CreatedDate   = formatdate("YYYY-MM-DD", timestamp())
  }
  
  # Resource naming convention
  resource_prefix = "${var.project_name}-${var.environment}"
  
  # Cloud-specific configuration
  cloud_config = {
    aws = {
      container_service = "ecs"
      registry_service  = "ecr"
      regions          = ["us-east-1", "us-west-2", "eu-west-1", "ap-southeast-1"]
    }
    azure = {
      container_service = "container-apps"
      registry_service  = "acr"
      regions          = ["East US", "West US 2", "West Europe", "Southeast Asia"]
    }
    gcp = {
      container_service = "cloud-run"
      registry_service  = "gcr"
      regions          = ["us-central1", "us-west1", "europe-west1", "asia-southeast1"]
    }
  }
  
  # Environment-specific defaults
  environment_config = {
    dev = {
      cpu                = "256"
      memory            = "512"
      desired_count     = 1
      enable_nat_gateway = false
      log_retention_days = 3
      enable_auto_scaling = false
    }
    staging = {
      cpu                = "512"
      memory            = "1024"
      desired_count     = 2
      enable_nat_gateway = true
      log_retention_days = 7
      enable_auto_scaling = true
    }
    prod = {
      cpu                = "1024"
      memory            = "2048"
      desired_count     = 3
      enable_nat_gateway = true
      log_retention_days = 30
      enable_auto_scaling = true
    }
  }
  
  # Resolved configuration
  resolved_region = var.cloud_provider == "aws" ? var.aws_region : (
    var.cloud_provider == "azure" ? var.azure_location : var.gcp_region
  )
  
  # Availability zones for AWS
  availability_zones = var.cloud_provider == "aws" ? (
    length(var.aws_availability_zones) > 0 ? var.aws_availability_zones : 
    slice(data.aws_availability_zones.available[0].names, 0, 2)
  ) : []
}

# Data sources (conditional based on cloud provider)
data "aws_availability_zones" "available" {
  count = var.cloud_provider == "aws" ? 1 : 0
  state = "available"
  
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "azurerm_client_config" "current" {
  count = var.cloud_provider == "azure" ? 1 : 0
}

data "google_client_config" "current" {
  count = var.cloud_provider == "gcp" ? 1 : 0
} 