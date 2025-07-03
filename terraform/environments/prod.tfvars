# Production Environment Configuration
# High availability, performance, and security

# Cloud Provider Selection
cloud_provider = "aws"  # Options: aws, azure, gcp

# Project Configuration
environment = "prod"
project_name = "nextjs-ecs"

# AWS Configuration (used when cloud_provider = "aws")
aws_region = "us-east-1"
aws_availability_zones = ["us-east-1a", "us-east-1b"]

# Azure Configuration (used when cloud_provider = "azure")
azure_location = "East US"
# azure_resource_group = "my-nextjs-prod-rg"  # Optional: specify existing RG

# GCP Configuration (used when cloud_provider = "gcp")
gcp_project = ""  # Required for GCP: your-gcp-project-id
gcp_region = "us-central1"

# Container Configuration (production sizing)
cpu = "512"           # 0.5 vCPU
memory = "1024"       # 1 GB
desired_count = 2     # High availability

# Network Configuration (full redundancy)
vpc_cidr = "10.0.0.0/16"
enable_nat_gateway = true      # Required for private subnets
single_nat_gateway = false     # Multi-AZ NAT for redundancy

# Application
container_port = 3000
health_check_path = "/api/health"

# Monitoring (extended retention)
log_retention_days = 30

# Scaling (enabled with aggressive scaling)
enable_auto_scaling = true
min_capacity = 1
max_capacity = 5
cpu_target_value = 60     # Lower threshold for faster scaling

# GitHub OIDC (⚠️  UPDATE THIS TO YOUR REPOSITORY ⚠️ )
github_repository = "YogiHarshil/terraform-ecs-site"
github_branch = "main" 