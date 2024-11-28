# Create directory for Kubernetes apt keyring
sudo mkdir /etc/apt/keyrings

# Update package lists
sudo apt-get update

# Install necessary packages for Kubernetes
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Download Kubernetes GPG key and add it to apt keyring
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository to apt sources list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists again
sudo apt-get update

# Install Kubernetes packages
sudo apt-get install -y kubelet kubeadm kubectl

# Hold Kubernetes packages to prevent accidental upgrades
sudo apt-mark hold kubelet kubeadm kubectl

# Enable IP forwarding
# sudo sysctl net.ipv4.conf.all.forwarding=1

# Accept forwarding rules
# sudo iptables -P FORWARD ACCEPT

# Disable swap
sudo swapoff -a



# Update package lists
sudo apt-get update

# Install necessary packages
sudo apt-get install ca-certificates curl

# Create directory for apt keyrings
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker GPG key and add it to apt keyring
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to apt sources list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo apt-get update

# Install Docker packages
yes | sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



# Configure containerd
sudo su <<EOF
cat > /etc/containerd/config.toml <<EOFF
[plugins."io.containerd.grpc.v1.cri"]
  systemd_cgroup = true
EOFF
systemctl restart containerd
exit
EOF

sudo modprobe br_netfilter
sudo echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo echo 1 > /proc/sys/net/ipv4/ip_forward


yes | sudo kubeadm reset 

sudo usermod -aG docker $USER && newgrp docker


