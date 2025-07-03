# Development Environment Configuration
# Cost-optimized for rapid iteration

# Cloud Provider Selection
cloud_provider = "aws"  # Options: aws, azure, gcp

# Project Configuration
environment = "dev"
project_name = "nextjs-ecs"

# AWS Configuration (used when cloud_provider = "aws")
aws_region = "us-east-1"
# aws_availability_zones = ["us-east-1a", "us-east-1b"]  # Optional: specify AZs

# Azure Configuration (used when cloud_provider = "azure")
azure_location = "East US"
# azure_resource_group = "my-nextjs-rg"  # Optional: specify existing RG

# GCP Configuration (used when cloud_provider = "gcp")
gcp_project = ""  # Required for GCP: your-gcp-project-id
gcp_region = "us-central1"

# Container Configuration (minimal for dev)
cpu = "256"           # 0.25 vCPU
memory = "512"        # 512 MB
desired_count = 1     # Single instance

# Network Configuration (cost optimized)
vpc_cidr = "10.0.0.0/16"
enable_nat_gateway = false     # Cost optimization: no NAT Gateway
single_nat_gateway = true      # If NAT is needed, use single gateway

# Application
container_port = 3000
health_check_path = "/api/health"

# Monitoring (minimal retention)
log_retention_days = 3

# Scaling (disabled for cost)
enable_auto_scaling = false
min_capacity = 1
max_capacity = 2
cpu_target_value = 70

# GitHub OIDC (⚠️  UPDATE THIS TO YOUR REPOSITORY ⚠️ )
github_repository = "YogiHarshil/terraform-ecs-site"  # UPDATE TO YOUR ACTUAL REPO
github_branch = "main" 