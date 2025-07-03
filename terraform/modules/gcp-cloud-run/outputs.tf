# GCP Cloud Run Module Outputs

# Application URLs
output "application_url" {
  description = "Application URL"
  value       = google_cloud_run_service.main.status[0].url
}

output "health_check_url" {
  description = "Health check endpoint URL"
  value       = "${google_cloud_run_service.main.status[0].url}${var.health_check_path}"
}

# GCP Resources
output "container_registry_url" {
  description = "Container registry URL"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.main.repository_id}"
}

output "service_name" {
  description = "Cloud Run service name"
  value       = google_cloud_run_service.main.name
}

output "service_url" {
  description = "Cloud Run service URL"
  value       = google_cloud_run_service.main.status[0].url
}

output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP region"
  value       = var.region
}

# Monitoring
output "log_sink_name" {
  description = "Cloud Logging sink name"
  value       = google_logging_project_sink.main.name
}

output "log_bucket_name" {
  description = "Logs storage bucket name"
  value       = google_storage_bucket.logs.name
}

# Container Registry
output "artifact_registry_repository" {
  description = "Artifact Registry repository name"
  value       = google_artifact_registry_repository.main.name
}

output "artifact_registry_location" {
  description = "Artifact Registry location"
  value       = google_artifact_registry_repository.main.location
} 