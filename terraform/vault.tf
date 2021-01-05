resource "google_storage_bucket" "vault_gcs" {
  name          = "dmilan-xyz-gcp-vault-01"
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

data "google_iam_policy" "vault_gcs_objectadmin" {
  binding {
    role = "roles/storage.objectAdmin"
    members = [
      "serviceAccount:${google_service_account.vault_service_account.email}",
    ]
  }
}

resource "google_service_account_key" "vault_service_account_key" {
  service_account_id = google_service_account.vault_service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "foo" {
    content     = base64decode(google_service_account_key.vault_service_account_key.private_key)
    filename = "${path.module}/.tout/vault_service_account_key.json"
}


resource "google_storage_bucket_iam_policy" "policy" {
  bucket = google_storage_bucket.vault_gcs.name
  policy_data = data.google_iam_policy.vault_gcs_objectadmin.policy_data
}


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

data "google_iam_policy" "crypto_key_encryter_decrypter" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

    members = [
       "serviceAccount:${google_service_account.vault_service_account.email}",
    ]
  }
}

resource "google_kms_crypto_key_iam_policy" "crypto_key" {
  crypto_key_id = google_kms_crypto_key.vault_key.id
  policy_data = data.google_iam_policy.crypto_key_encryter_decrypter.policy_data
}

