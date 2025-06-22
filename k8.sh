#!/bin/bash

set -e

echo "[Step 1] Updating system and installing dependencies..."
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

echo "[Step 2] Adding Kubernetes GPG key..."
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "[Step 3] Adding Kubernetes repo..."
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] \
https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "[Step 4] Installing kubelet, kubeadm, kubectl..."
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

echo "[Step 5] Holding package versions..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "[Step 6] Disabling swap (required for Kubernetes)..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/' /etc/fstab

echo "[Step 7] Enabling required kernel modules..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

sudo modprobe br_netfilter

echo "[Step 8] Setting sysctl params for Kubernetes networking..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

echo "[✅ Done] Kubernetes components installed!"
echo "To create a cluster: sudo kubeadm init"
