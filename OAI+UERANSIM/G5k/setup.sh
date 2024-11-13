# Create directory for Kubernetes apt keyring
sudo-g5k mkdir /etc/apt/keyrings

# Update package lists
sudo-g5k apt-get update

# Install necessary packages for Kubernetes
sudo-g5k apt-get install -y apt-transport-https ca-certificates curl gpg

# Download Kubernetes GPG key and add it to apt keyring
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo-g5k gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository to apt sources list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo-g5k tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists again
sudo-g5k apt-get update

# Install Kubernetes packages
sudo-g5k apt-get install -y kubelet kubeadm kubectl

# Hold Kubernetes packages to prevent accidental upgrades
sudo-g5k apt-mark hold kubelet kubeadm kubectl

# Enable IP forwarding
# sudo-g5k sysctl net.ipv4.conf.all.forwarding=1

# Accept forwarding rules
# sudo-g5k iptables -P FORWARD ACCEPT

# Disable swap
sudo-g5k swapoff -a



# Update package lists
sudo-g5k apt-get update

# Install necessary packages
sudo-g5k apt-get install ca-certificates curl

# Create directory for apt keyrings
sudo-g5k install -m 0755 -d /etc/apt/keyrings

# Download Docker GPG key and add it to apt keyring
sudo-g5k curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo-g5k chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to apt sources list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo-g5k tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo-g5k apt-get update

# Install Docker packages
yes | sudo-g5k apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



# Configure containerd
sudo-g5k su <<EOF
cat > /etc/containerd/config.toml <<EOFF
[plugins."io.containerd.grpc.v1.cri"]
  systemd_cgroup = true
EOFF
systemctl restart containerd
exit
EOF

sudo-g5k modprobe br_netfilter
sudo-g5k echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo-g5k echo 1 > /proc/sys/net/ipv4/ip_forward


yes | sudo-g5k kubeadm reset 

sudo-g5k usermod -aG docker $USER && newgrp docker


