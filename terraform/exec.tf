# google_compute_address.external_ip_ingress.addres
resource "null_resource" "glcoud-credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone us-central1-a --project ${var.project}"
    interpreter = ["bash", "-c"]
  }
  depends_on = [
    google_container_cluster.primary
  ]
}



resource "null_resource" "helm-ingress-nginx" {
  provisioner "local-exec" {
    command = <<EOT
        helm upgrade --install  \
        ingress-nginx ingress-nginx/ingress-nginx --wait --timeout 900s \
        --namespace ingress-nginx --create-namespace \
        -f  values/values-ingress-nginx.yaml \
        --set controller.service.loadBalancerIP="${google_compute_address.external_ip_ingress.address}" 
    EOT
    interpreter = ["bash", "-c"]
  }
  depends_on = [
    null_resource.glcoud-credentials
  ]
}

resource "null_resource" "helm-cert-manager" {
  provisioner "local-exec" {
    command = <<EOT
        helm upgrade --install  \
        cert-manager jetstack/cert-manager --wait --timeout 900s \
        --namespace cert-manager --create-namespace \
        --version v1.1.0 \
        --set installCRDs=true
      EOT
    interpreter = ["bash", "-c"]
  }
  depends_on = [
    null_resource.glcoud-credentials
  ]
}

resource "null_resource" "letsencrypt" {
  provisioner "local-exec" {
    command = <<EOT
        kubectl apply -f  lets-encrypt/templates/
      EOT
    interpreter = ["bash", "-c"]
  }
  depends_on = [
    null_resource.helm-cert-manager
  ]
}


resource "null_resource" "vault_helm" {
  provisioner "local-exec" {
    command = <<EOT
        kubectl create ns vault; \
        kubectl -n vault create secret generic gcp-key \
        --from-file=privatekey=.tout/vault_service_account_key.json; \
        helm repo add hashicorp https://helm.releases.hashicorp.com; \
        helm upgrade --install  \
        vault hashicorp/vault --wait --timeout 900s \
        --namespace vault --create-namespace \
        -f  values/values-vault.yaml 
      EOT
    interpreter = ["bash", "-c"]
  }
  depends_on = [
    null_resource.glcoud-credentials
  ]
}