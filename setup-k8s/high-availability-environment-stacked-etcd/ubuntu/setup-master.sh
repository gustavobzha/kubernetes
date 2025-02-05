#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Add private SSH file for access"
cat >>~/.ssh/id_rsa<<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA1VbMFF4ddcW5/Frbo9I2XhLQlxpW31N3j/TSiAM44+R9yIGc
VhnG0r8/nQZFHz+dAkY0Meb9ZOL6XtQwsdyvpy9s4nZOqqLZSqhsm58/VB0utRBr
ir8bgzsAsFjCtThJJq42HWVSoAp9alDHyN1MyJ9DfQ1UxaJS5v746UmdDV/Ty5Mz
G1L/zDDuBmOn5ODvS6P3KIPS+ab7RkpeHnBZd0Sfmv6N4Fhi2FsCXVf9raU6bN/4
YeefZwFanZNBD5BbySZJRYc4y+AeZKR7JNsLyhm4KXGtj1JhOoVRJYwYr1H1e0Qr
hSQftDVbCYTutU7BK0Tre4ftriVoRsIj+2CU5wIDAQABAoIBAFe0wlvRQW1Mp6Se
udOEtYNBWu30DyjrCKlvLipqoLXYFvoahupC2KGFrKJilII/Rc5MjGLDowMZ6XKY
65gDsVcbQTltB/RQ1OJDkbr84i0zfiNEJ+I3pRjzZdoZ85pLFI/JaUf2gtx2046k
vS3QBSQpjbZYh7Rkgo6i3jQSZnW7YkIqTzIYuREGRTlzfXLwhWov468YcjpbdRXb
/ReNHZxv1py2Z42rx4zM65VfZUWUxBEk7QVIN7dIcGR5LcECdha8TQChmfMk8N7W
NQIospYvVNdT/vexnEY0/Cqp9lLg8+939MIEhvqGHr30FKBon2wlHu1PxSfvxS41
AVD275ECgYEA90Y1BV+0ms90BI1PPRfBJBkOvyxwVrcmf+hTiCLUjjxbbo2HeoQj
o7RSWxR1S2sPnlGZmF0w33XU8bms7i616WtpwhHAof+Gp2QJWEHnzuSs3dTwMOYj
maIepJItVDrzylYgHo5JivVEC1Xgmt3m16Iffld9Le2thnatn1AMgYkCgYEA3N4H
5rbqjqnVc731icNAm9Nf40TimzyV3ZwmrTTkMa4TJmL6lXupmDA9IuWfhhjfTpzi
ru+s2WRXFZADweIO1llX0HWzgSMb7Fk3dQOtHnHjIyTFiL/xY/kw2CcvNlndjEZ7
lg/vaJAvQkQOuGHP/mTRD7yN2MqKZkO2TjTq9u8CgYBZgg1xS4qJu2yItUoomC+u
zG89Hm3vxc5m4IdUMR91+T0zkIGpBKoN+RkSpR4sVa3KpkkOETW+vd1+PrLtaPUq
cFpRCLINMfzhHOIRE5JAnyBAEHN9j+D1HO0wr0U/RzO2W2S3CtRuO4gM/mIWTRrh
lWsHBc5nULDOiqkgkQ5l2QKBgQDaMQHvO062xzKWV9fEU7508jktBLU0lIKc3hEb
VUAFkClc57UTjYn6TdVnrx6L0/Bu8e/C0AWa8VRSeeYsWE0+Fh75Uf2WGoAQWga+
M3aHuAyigEYglTY8BEXrk7JBaD/EvzCCC5YAX0hAl4lPP1nBwAkEGcqrm1NkOYpU
8lQYwwKBgBsHJyMXQIlZ0B4vtr7rKSd9Umq1ZRZEVUqBiZDq5i1yJrEj2G3iqWB0
7EnbdPT9npAkwmhzdN9spK+8kGzvTzJfbRISpl4fBt9b/UoZ08S+7mMsE98EcWux
o0gwlCqbzGbjRK0vHHkyZwUCaxp4/f46ogEm3kVtVHACm26Vkt0J
-----END RSA PRIVATE KEY-----
EOF

echo "[TASK 3] Change private key permission"
chmod 400 ~/.ssh/id_rsa

echo "[TASK 3] Pull master connection token"
scp -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no root@192.168.56.11:/joinmaster.sh /joinmaster.sh

echo "[Task 4] Join the cluster"
bash /joinmaster.sh

# echo "[TASK 2] Initialize Kubernetes Cluster"
# kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=192.168.56.2>> /root/kubeinit.log

# echo "[TASK 3] Deploy Calico network"
# kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

# echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
# kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

# echo "[TASK 5] Setup public key for workers to access master"
# cat >>~/.ssh/authorized_keys<<EOF
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVVswUXh11xbn8Wtuj0jZeEtCXGlbfU3eP9NKIAzjj5H3IgZxWGcbSvz+dBkUfP50CRjQx5v1k4vpe1DCx3K+nL2zidk6qotlKqGybnz9UHS61EGuKvxuDOwCwWMK1OEkmrjYdZVKgCn1qUMfI3UzIn0N9DVTFolLm/vjpSZ0NX9PLkzMbUv/MMO4GY6fk4O9Lo/cog9L5pvtGSl4ecFl3RJ+a/o3gWGLYWwJdV/2tpTps3/hh559nAVqdk0EPkFvJJklFhzjL4B5kpHsk2wvKGbgpca2PUmE6hVEljBivUfV7RCuFJB+0NVsJhO61TsErROt7h+2uJWhGwiP7YJTn vagrant@master01
# EOF

# echo "[TASK 6] Setup kubectl"
# mkdir -p $HOME/.kube
# cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# chown $(id -u):$(id -g) $HOME/.kube/config