
# """""""""""""""""""""""""""""""""""""""""""""" install docker """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
echo "sudo-g5k apt-get update -y"
sudo-g5k apt-get update -y

echo "sudo-g5k apt-get install -y ca-certificates curl -y"
sudo-g5k apt-get install -y ca-certificates curl -y

echo "sudo-g5k install -m 0755 -d /etc/apt/keyrings"
sudo-g5k install -m 0755 -d /etc/apt/keyrings

echo "sudo-g5k curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
sudo-g5k curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

echo "sudo-g5k chmod a+r /etc/apt/keyrings/docker.asc"
sudo-g5k chmod a+r /etc/apt/keyrings/docker.asc

echo "Ajout du dépôt Docker"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
  sudo-g5k tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "sudo-g5k apt-get update -y"
sudo-g5k apt-get update -y

echo "sudo-g5k apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y"
sudo-g5k apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#echo "sudo-g5k usermod -aG docker \$USER && newgrp docker"
#sudo-g5k usermod -aG docker $USER && newgrp docker

if [ "$1" != "--post-newgrp" ]; then
  echo "Ajout de l'utilisateur actuel au groupe Docker et bascule vers le nouveau groupe"
  sudo-g5k usermod -aG docker $USER
  exec newgrp docker <<EONG
$0 --post-newgrp
EONG
  exit 0
fi

# """""""""""""""""""""""""""""""""""""""""""""" install Kubernetes """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
echo "sudo-g5k apt-get update"
sudo-g5k apt-get update

echo "sudo-g5k apt-get install -y apt-transport-https ca-certificates curl gpg"
sudo-g5k apt-get install -y apt-transport-https ca-certificates curl gpg

echo "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo-g5k gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo-g5k gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Ajout du dépôt Kubernetes"
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo-g5k tee /etc/apt/sources.list.d/kubernetes.list

echo "sudo-g5k apt-get update"
sudo-g5k apt-get update

echo "sudo-g5k apt-get install -y kubelet kubeadm kubectl"
sudo-g5k apt-get install -y kubelet kubeadm kubectl

echo "sudo-g5k apt-mark hold kubelet kubeadm kubectl"
sudo-g5k apt-mark hold kubelet kubeadm kubectl

# Désactiver swap
echo "sudo-g5k swapoff -a"
sudo-g5k swapoff -a

# Configurer containerd
echo "sudo-g5k su <<EOF"
sudo-g5k su <<EOF
cat > /etc/containerd/config.toml <<EOFF
[plugins."io.containerd.grpc.v1.cri"]
  systemd_cgroup = true
EOFF
systemctl restart containerd
exit
EOF

echo "sudo-g5k modprobe br_netfilter"
sudo-g5k modprobe br_netfilter

echo "sudo-g5k echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables"
sudo-g5k echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

echo "sudo-g5k echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo-g5k echo 1 > /proc/sys/net/ipv4/ip_forward

echo "yes | sudo-g5k kubeadm reset"
yes | sudo-g5k kubeadm reset


# Disable swap
sudo-g5k swapoff -a

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


