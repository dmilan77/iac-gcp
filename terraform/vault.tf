resource "google_storage_bucket" "auto-expire" {
  name          = "dmilan-xyz-gcp-vault"
  location      = "US"
  force_destroy = true

  # lifecycle_rule {
  #   condition {
  #     age = 3
  #   }
  #   action {
  #     type = "Delete"
  #   }
  # }
}

resource "google_service_account" "vault_service_account" {
  account_id   = "vaultsa01"
  display_name = "vault service account"
}


# resource "google_service_account_key" "vault_service_account_key" {
#   service_account_id = google_service_account.vault_service_account.name
#   public_key_type    = "TYPE_X509_PEM_FILE"
# }

resource "google_kms_key_ring" "main_keyring" {
  name     = "main-keyring-01"
  location = "global"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "vault_key" {
  name            = "vault-key-01"
  key_ring        = google_kms_key_ring.main_keyring.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

# data "google_iam_policy" "admin" {
#   binding {
#     role = "roles/iam.serviceAccountUser"

#     members = [
#       "user:jane@example.com",
#     ]
#   }
# }

