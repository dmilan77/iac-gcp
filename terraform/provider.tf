provider "google" {
  version = "~> 3.49.0"
  region  = "us-central1"
  project = "data-protection-01"
}
terraform {
  backend "gcs" {
    bucket  = "tfstate-data-protection-01"
    prefix  = "terraform/state/gke/gke-demo-cluster-01"
  }
}