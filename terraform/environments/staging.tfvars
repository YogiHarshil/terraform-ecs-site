# Staging Environment Configuration
# Balanced between dev and prod for testing

# Cloud Provider Selection
cloud_provider = "aws"  # Options: aws, azure, gcp

# Project Configuration
environment = "staging"
project_name = "nextjs-ecs"

# AWS Configuration (used when cloud_provider = "aws")
aws_region = "us-west-2"  # Different region for testing
aws_availability_zones = ["us-west-2a", "us-west-2b"]

# Azure Configuration (used when cloud_provider = "azure")
azure_location = "West US 2"
# azure_resource_group = "my-nextjs-staging-rg"  # Optional: specify existing RG

# GCP Configuration (used when cloud_provider = "gcp")
gcp_project = ""  # Required for GCP: your-gcp-project-id
gcp_region = "us-west1"

# Container Configuration (balanced for staging)
cpu = "512"           # 0.5 vCPU
memory = "1024"       # 1 GB
desired_count = 2     # For testing load balancing

# Network Configuration (cost optimized but with some redundancy)
vpc_cidr = "10.1.0.0/16"   # Different CIDR for isolation
enable_nat_gateway = true  # Enable for realistic testing
single_nat_gateway = true  # Cost optimization: use single gateway

# Application
container_port = 3000
health_check_path = "/api/health"

# Monitoring (moderate retention)
log_retention_days = 7

# Scaling (enabled for testing)
enable_auto_scaling = true
min_capacity = 1
max_capacity = 4
cpu_target_value = 65      # Slightly more aggressive than prod

# GitHub OIDC (⚠️  UPDATE THIS TO YOUR REPOSITORY ⚠️ )
github_repository = "YogiHarshil/terraform-ecs-site"
github_branch = "main" 