helm upgrade --install  ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx --create-namespace \
    -f  values/values-ingress-nginx.yaml --set controller.service.loadBalancerIP="35.192.177.124"

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --version v1.1.0 \
  --set installCRDs=true

kubectl apply -f  lets-encrypt/templates/