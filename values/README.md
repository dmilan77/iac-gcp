
## Install instruction
```
gcloud container clusters get-credentials gitops-demo --zone us-central1-a --project data-protection-01

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts                        
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install  ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx --create-namespace \
    -f  values/values-ingress-nginx.yaml

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --version v1.1.0 \
  --set installCRDs=true

kubectl apply -f  lets-encrypt/templates/



helm upgrade --install prometheus prometheus-community/prometheus --namespace prometheus --create-namespace \
    -f  values/values-prometheus.yaml \
    -f  values/prometheus_alerting_rules.yaml \
    -f  values/alertmanager-config.yaml

helm upgrade --install  grafana grafana/grafana --namespace grafana --create-namespace \
    -f  values/values-grafana.yaml



# curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/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


# import dashboard #6417
# 7249
# 1621

```

serverFiles:  
  alerting_rules.yml: