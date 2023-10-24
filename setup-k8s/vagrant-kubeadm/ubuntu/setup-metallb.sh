ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no root@192.168.56.2 <<EOF
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system \
             --for=condition=ready pod \
             --selector=app=metallb \
             --timeout=300s
cat <<SCRIPT | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - 192.168.56.200-192.168.56.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
SCRIPT
EOF