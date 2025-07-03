# Azure Container Apps Module for Next.js Application

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.common_tags
}

# Log Analytics Workspace for Container Apps
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.resource_prefix}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  
  tags = var.common_tags
}

# Container Registry
resource "azurerm_container_registry" "main" {
  name                = replace("${var.resource_prefix}acr", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.environment == "prod" ? "Premium" : "Basic"
  admin_enabled       = true
  
  tags = var.common_tags
}

# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "${var.resource_prefix}-env"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  
  tags = var.common_tags
}

# Container App
resource "azurerm_container_app" "main" {
  name                         = var.resource_prefix
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  
  template {
    min_replicas = var.enable_auto_scaling ? var.min_capacity : var.desired_count
    max_replicas = var.enable_auto_scaling ? var.max_capacity : var.desired_count
    
    container {
      name   = var.resource_prefix
      image  = "${azurerm_container_registry.main.login_server}/${var.resource_prefix}:latest"
      cpu    = tonumber(var.cpu) / 1000.0  # Convert to cores
      memory = "${var.memory}Mi"
      
      env {
        name  = "NODE_ENV"
        value = var.environment == "prod" ? "production" : "development"
      }
      
      env {
        name  = "PORT"
        value = tostring(var.container_port)
      }
      
      # Health probes
      liveness_probe {
        path                = var.health_check_path
        port                = var.container_port
        transport           = "HTTP"
        interval_seconds    = 30
      }
      
      readiness_probe {
        path                = var.health_check_path
        port                = var.container_port
        transport           = "HTTP"
        interval_seconds    = 10
      }
    }
  }
  
  ingress {
    allow_insecure_connections = var.environment != "prod"
    external_enabled           = true
    target_port               = var.container_port
    transport                 = "http"
    
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
  
  tags = var.common_tags
}

# Note: Auto-scaling is managed through template min_replicas and max_replicas 