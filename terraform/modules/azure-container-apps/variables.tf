# Azure Container Apps Module Variables

variable "location" {
  description = "Azure location for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
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
  description = "Enable auto scaling for container app"
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