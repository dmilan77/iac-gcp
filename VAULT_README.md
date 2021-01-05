vault secrets enable -path=secret kv-v2

vault kv put secret/dev/project/mainproject \
  AWS_ACCESS_KEY_ID="dsssss" \
  AWS_SECRET_ACCESS_KEY="dffff" \
  SECRET_KEY="ksdnfksdfnksd" \
  REDIS_PASSWORD=""

vault read -format json secret/data/dev/project/mainproject

vault token create -period=5m
