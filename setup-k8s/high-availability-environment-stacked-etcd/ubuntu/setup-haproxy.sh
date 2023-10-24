#!/bin/bash

echo "[TASK 1] show whoami"
whoami

echo "[TASK 2] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1

echo "[TASK 3] Install haproxy dependency"
apt-get install -y haproxy

echo "[TASK 4] Configuring haproxy"
cat >> /etc/haproxy/haproxy.cfg <<EOF
frontend kubernetes
	mode tcp
	bind 192.168.56.30:6443
	option tcplog
	default_backend k8s-masters
	
backend k8s-masters
	mode tcp
	balance roundrobin
	option tcp-check
	server k8s-master-0 192.168.56.11:6443 check fall 3 rise 2
	server k8s-master-1 192.168.56.12:6443 check fall 3 rise 2
EOF

echo "[TASK 5] Restart haproxy service"
systemctl restart haproxy
systemctl status haproxy