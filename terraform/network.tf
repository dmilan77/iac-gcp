resource "google_compute_network" "gitops_gke_network" {
  name = "vpc-gitops-gke-network"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "gitops_gke_subnetwork_us_central1" {
  name          = "vpc-gitops-gke-subnetwork-us-central1"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.gitops_gke_network.id
#   secondary_ip_range {
#     range_name    = "tf-test-secondary-range-update1"
#     ip_cidr_range = "192.168.10.0/24"
#   }
}





resource "google_compute_address" "internal_with_subnet_and_address" {
  name         = "git-address"
  subnetwork   = google_compute_subnetwork.gitops_gke_subnetwork_us_central1.id
  address_type = "INTERNAL"
  address      = "10.2.80.80"
  region       = "us-central1"
}

resource "google_compute_address" "external_ip_ingress" {
  name         = "ingress-external-address"
  address_type = "EXTERNAL"
}



data "google_dns_managed_zone" "env_dns_zone" {
  name = "dmilangcp-xyz"
}

resource "google_dns_record_set" "dns_grafana" {
  name = "grafana.${data.google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.env_dns_zone.name

  rrdatas = [google_compute_address.external_ip_ingress.address]
}

resource "google_dns_record_set" "dns_tekton" {
  name = "tekton.${data.google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.env_dns_zone.name

  rrdatas = [google_compute_address.external_ip_ingress.address]
}


# grafana.dmilangcp.xyz
output external_ip_ingress {
  value       = google_compute_address.external_ip_ingress.address
  sensitive   = false
  description = "description"
  depends_on  = []
}
