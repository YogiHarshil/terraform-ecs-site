# GCP Cloud Run Module for Next.js Application

# Enable required APIs
resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"
  
  disable_on_destroy = false
}

resource "google_project_service" "container_registry" {
  project = var.project_id
  service = "containerregistry.googleapis.com"
  
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  
  disable_on_destroy = false
}

# Artifact Registry Repository (modern replacement for Container Registry)
resource "google_artifact_registry_repository" "main" {
  location      = var.region
  repository_id = var.resource_prefix
  description   = "Container registry for ${var.resource_prefix}"
  format        = "DOCKER"
  
  labels = var.common_labels
  
  depends_on = [google_project_service.artifact_registry]
}

# Cloud Run Service
resource "google_cloud_run_service" "main" {
  name     = var.resource_prefix
  location = var.region
  project  = var.project_id
  
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.main.repository_id}/${var.resource_prefix}:latest"
        
        ports {
          container_port = var.container_port
        }
        
        env {
          name  = "NODE_ENV"
          value = var.environment == "prod" ? "production" : "development"
        }
        
        env {
          name  = "PORT"
          value = tostring(var.container_port)
        }
        
        resources {
          limits = {
            cpu    = var.cpu == "256" ? "0.25" : var.cpu == "512" ? "0.5" : "1"
            memory = "${var.memory}Mi"
          }
        }
        
        # Liveness probe for health checks
        liveness_probe {
          http_get {
            path = var.health_check_path
            port = var.container_port
          }
          initial_delay_seconds = 30
          timeout_seconds       = 5
          period_seconds        = 10
        }
      }
      
      # Container concurrency and scaling
      container_concurrency = var.environment == "prod" ? 80 : 100
      timeout_seconds      = 300
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = tostring(var.min_capacity)
        "autoscaling.knative.dev/maxScale" = tostring(var.max_capacity)
        "run.googleapis.com/cpu-throttling" = var.environment == "prod" ? "false" : "true"
        "run.googleapis.com/execution-environment" = "gen2"
      }
      
      labels = var.common_labels
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  depends_on = [google_project_service.cloud_run]
}

# IAM policy to allow public access
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_service.main.location
  project  = google_cloud_run_service.main.project
  service  = google_cloud_run_service.main.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Cloud Logging Sink for structured logs
resource "google_logging_project_sink" "main" {
  name = "${var.resource_prefix}-logs"
  
  destination = "storage.googleapis.com/${google_storage_bucket.logs.name}"
  
  filter = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${google_cloud_run_service.main.name}\""
  
  unique_writer_identity = true
}

# Storage bucket for logs (optional - for long-term storage)
resource "google_storage_bucket" "logs" {
  name     = "${var.project_id}-${var.resource_prefix}-logs"
  location = var.region
  
  lifecycle_rule {
    condition {
      age = var.log_retention_days
    }
    action {
      type = "Delete"
    }
  }
  
  labels = var.common_labels
}

# Grant the logging service account write access to the bucket
resource "google_storage_bucket_iam_member" "logs_writer" {
  bucket = google_storage_bucket.logs.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.main.writer_identity
} 