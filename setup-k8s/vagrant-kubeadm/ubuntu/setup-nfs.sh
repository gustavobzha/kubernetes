#!/bin/bash

apt install nfs-kernel-server -y > /dev/null 2>&1
mkdir /opt/dados
chmod 1777 /opt/dados

echo "/opt/dados *(rw,sync,no_root_squash,subtree_check)" >> /etc/exports
exportfs -ar