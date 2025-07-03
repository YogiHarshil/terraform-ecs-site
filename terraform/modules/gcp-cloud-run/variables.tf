# GCP Cloud Run Module Variables

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for deployment"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default     = {}
}

# Container Configuration
variable "cpu" {
  description = "CPU units for container"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory in MiB for container"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Desired number of container instances"
  type        = number
  default     = 1
}

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

# Monitoring
variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 3
}

# Scaling
variable "enable_auto_scaling" {
  description = "Enable auto scaling for Cloud Run service"
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "Minimum number of instances for auto scaling"
  type        = number
  default     = 0
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