#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --control-plane-endpoint "k8s-haproxy:6443" --upload-certs

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save master join command to /joinmaster.sh"
kubeadm token create --print-join-command --certificate-key $(kubeadm certs certificate-key) > /joinmaster.sh 2>/dev/null

echo "[TASK 5] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 6] Setup public key for workers to access master"
cat >>~/.ssh/authorized_keys<<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVVswUXh11xbn8Wtuj0jZeEtCXGlbfU3eP9NKIAzjj5H3IgZxWGcbSvz+dBkUfP50CRjQx5v1k4vpe1DCx3K+nL2zidk6qotlKqGybnz9UHS61EGuKvxuDOwCwWMK1OEkmrjYdZVKgCn1qUMfI3UzIn0N9DVTFolLm/vjpSZ0NX9PLkzMbUv/MMO4GY6fk4O9Lo/cog9L5pvtGSl4ecFl3RJ+a/o3gWGLYWwJdV/2tpTps3/hh559nAVqdk0EPkFvJJklFhzjL4B5kpHsk2wvKGbgpca2PUmE6hVEljBivUfV7RCuFJB+0NVsJhO61TsErROt7h+2uJWhGwiP7YJTn vagrant@master01
EOF

echo "[TASK 7] Setup kubectl"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config