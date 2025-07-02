variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "nextjs-ecs"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "desired_count" {
  description = "Desired ECS tasks"
  type        = number
  default     = 2
}

variable "cpu" {
  description = "CPU units"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory in MiB"
  type        = string
  default     = "512"
} 