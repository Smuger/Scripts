UFW
---

Check if anything gets blocked
```bash
sudo tail -f /var/log/syslog | grep UFW
```

SCP
---

Send a file over using key to login
```bash
scp -i ~/.ssh/id_rsa myfile.txt user@192.168.1.100:/home/user/
```

Datadog
---

Check if linux agent is sending the logs
```bash
sudo datadog-agent status
```

Enable DCGM GPU monitoring (Using Docker)
```
docker run \
  --pid=host \
  --privileged \
  -e DCGM_EXPORTER_INTERVAL=5000 \
  --gpus all \
  -d -v /proc:/proc \
  -v $PWD/default-counters.csv:/etc/dcgm-exporter/default-counters.csv \
  -p 9400:9400 \
  --name dcgm-exporter \
  --label com.datadoghq.ad.check_names='["dcgm"]' \
  --label com.datadoghq.ad.init_configs='[{}]' \
  --label com.datadoghq.ad.instances='[{"openmetrics_endpoint": "http://%%host%%:9400/metrics"}]' \
  nvcr.io/nvidia/k8s/dcgm-exporter:3.1.7-3.1.4-ubuntu20.04
```

Private Public Key
---

Create public key from private
```bash
ssh-keygen -y -f private.key
```

StrongSwan
---

Debugging
```bash
tcpdump -i Tunnel1 icmp
nc -l 12345
nc <server-ip> 12345 -v
iptables-save > iptables_backup
ip route show table all
cat /proc/sys/net/ipv4/ip_forward
sudo ip xfrm state
sudo ip xfrm policy
ip tunnel
tail -100 /var/log/auth.log | grep charon
cat /proc/sys/net/ipv4/ip_forward
cat /var/log/syslog | grep "UFW BLOCK" # Check if UFW is blocking stuff
ip route get to 172.31.21.160
sudo iptables -t nat -I POSTROUTING 1 -s 172.31.0.0/16 -o ens3 -j LOG --log-prefix "NAT DEBUG: "
swanctl --list-sas
sudo tshark -i ens3 -f "icmp" -V
conntrack -L
sudo iptables -t nat -L POSTROUTING -n -v # Check where packets are coming from

iptables -t nat -D POSTROUTING -s 172.31.0.0/16 -o ens3 -j MASQUERADE # Delete nat iptables rule
iptables -t nat -A POSTROUTING -s 172.31.0.0/16 -o ens3 -j MASQUERADE # Add nat iptables rule

sudo hping3 -a 172.31.0.5 -1 10.0.1.243 # send ping using different source address

sudo ip route add 172.31.0.0/16 via 10.0.1.103 dev ens3 # Add Route traffic via VPN
sudo ip route delete 172.31.0.0/16 via 10.0.1.103 dev ens3 # Delete Route traffic via VPN

sudo ufw allow from 152.37.100.101 to any port 22
sudo ufw allow from 35.80.100.101 to any port 500 proto udp
sudo ufw allow from 10.0.0.0/8
sudo ufw status verbose
```

Google Takeout Photo 
---

Date fix
```
# Install exiftool
exiftool "-FileModifyDate<DateTimeOriginal" *
exiftool "-FileModifyDate<MediaCreateDate" *
exiftool "-FileModifyDate<ModifyDate" *
exiftool -d "%s" -tagsfromfile %d%f.%e.json "-DateTimeOriginal<PhotoTakenTimeTimestamp" "-FileCreateDate<PhotoTakenTimeTimestamp" "-FileModifyDate<PhotoTakenTimeTimestamp" -overwrite_original .
```


NVIDIA
---

Check drivers
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/driver/tags

Install on Ubuntu 
# https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/index.html#ubuntu
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt install cuda-drivers
sudo apt-get install cuda-toolkit
reboot
```

Install driver on VM Rocky 8 
---
```
sudo dnf makecache
sudo dnf upgrade -y
sudo dnf install -y pciutils
sudo dnf install -y epel-release
sudo dnf install -y dkms
sudo dnf install -y gcc kernel-devel kernel-headers dkms make

# Driver
wget https://uk.download.nvidia.com/tesla/550.127.08/nvidia-driver-local-repo-rhel8-550.127.08-1.0-1.x86_64.rpm
sudo rpm -i nvidia-driver-local-repo-rhel8-550.127.08-1.0-1.x86_64.rpm
sudo dnf -y module install nvidia-driver:latest-dkms

# Toolkit
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
sudo dnf config-manager --enable nvidia-container-toolkit-experimental
dnf install -y nvidia-container-toolkit
```


AWS SSM
---

Setup SSM on Amazon  2023
---
```bash
# 1. Attach IAM role with permissions: AmazonSSMManagedInstanceCore

# 2. Run in user data:
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl status amazon-ssm-agent
```

EKS
---

Access cluster
```bash
aws eks --region REGION update-kubeconfig --name CLUSTER_NAME
```



Check certificate
---

https://www.sslshopper.com/ssl-checker.html

Ubuntu
---

Upgrade Distro
```bash
sudo apt update && sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo reboot
sudo do-release-upgrade -f DistUpgradeViewNonInteractive
sudo reboot

# POST
sudo apt autoremove --purge
```

Create admin user
```
#!/bin/bash

# Variables
USERNAME="Bad-User_123"               # Change this to your "bad" username
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1y..."  # Replace with your actual public key
GROUP="ubuntu"                        # Group to add the user to

# Step 1: Create the user (allowing bad name)
echo "Creating user: $USERNAME"
sudo useradd --badname --create-home --shell /bin/bash "$USERNAME"

# Set ownership
sudo chown "$USERNAME":"$USERNAME" /home/"$USERNAME"

# Step 2: Add user to the sudo group
echo "Adding $USERNAME to the sudo group"
sudo usermod -aG sudo "$USERNAME"

# Step 3: Disable sudo password prompt
echo "Disabling sudo password prompt for $USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USERNAME"

# Step 4: Add SSH public key
echo "Setting up SSH key for $USERNAME"
sudo mkdir -p /home/"$USERNAME"/.ssh
echo "$PUBLIC_KEY" | sudo tee /home/"$USERNAME"/.ssh/authorized_keys
sudo chmod 700 /home/"$USERNAME"/.ssh
sudo chmod 600 /home/"$USERNAME"/.ssh/authorized_keys
sudo chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh

# Step 5: Add the user to the specified group
echo "Adding $USERNAME to the $GROUP group"
sudo usermod -aG "$GROUP" "$USERNAME"

# Confirmation
echo "✅ User $USERNAME created and configured successfully!"
```

Kubernetes
---

Find where pods are running
```bash
kubectl get pods -A -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,NODE:.spec.nodeName'
```

Check if BGP v2 is installed for Cilium
```
kubectl api-resources | grep BGP
```

Forward K8s service via Bastion (Ubuntu)
```bash
ssh -L (Port-On-Your-Machine):(K8s-Service-Local-IP):(Port-Of-The-Service-In-K8s) -J ubuntu@(Bastion-IP) ubuntu@(Master-Node-IP)
```
e.g.
```bash
ssh -L 9400:10.10.0.1:9400 -J ubuntu@38.100.100.100 ubuntu@10.0.0.1
```

Github
---

Github switch accounts in terminal
```
gh auth switch
gh repo clone <repo-https>
```

Squash PR (n= Number or commits)
```
git fetch origin

git checkout <branch-name>

git rebase -i HEAD~n
```
```
pick abc123 Commit message 1
squash def456 Commit message 2
squash ghi789 Commit message 3
```
```
git push origin <branch-name> --force
```



React Native
---

Debug mode
```
CMD + D
```



Debuging
---

HTTP server
```
sudo python3 -m http.server 80
```

Python
---

Check which versions are installed (pyenv)
```
pyenv versions
```

List versions you can install (pyenv)
```
pyenv install --list
```

Install new version (pyenv)
```
pyenv install -v 3.8.18
```

Ansible
---
Install on raspberry pi 3
```
sudo apt install python3-pip -y
sudo pip3 install ansible
```

Install on raspberry pi 4
```
sudo apt install python3-pip -y
# Open a new python virtual environment
pip3 install ansible
```

Install on MacOS
```
python3 -m pip install --user ansible
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc 
```

Prometheus
---
Client
```
#!/bin/bash

PROMETHEUS_DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz"
PROMETHEUS_FOLDER_NAME="prometheus-client"

wget -O "${PROMETHEUS_FOLDER_NAME}".tar.gz "${PROMETHEUS_DOWNLOAD_URL}" .

tar xvfz "${PROMETHEUS_FOLDER_NAME}".tar.gz

mv node_exporter* "${PROMETHEUS_FOLDER_NAME}"

rm "${PROMETHEUS_FOLDER_NAME}".tar.gz

cd "${PROMETHEUS_FOLDER_NAME}"

rm -r LICENSE NOTICE
```
---
Server
```
#!/bin/bash

PROMETHEUS_DOWNLOAD_URL="https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-amd64.tar.gz"
PROMETHEUS_FOLDER_NAME="prometheus-server"

wget -O "${PROMETHEUS_FOLDER_NAME}".tar.gz "${PROMETHEUS_DOWNLOAD_URL}" .

tar xvfz "${PROMETHEUS_FOLDER_NAME}".tar.gz

rm "${PROMETHEUS_FOLDER_NAME}".tar.gz

mv prometheus-2.45.3.linux-amd64 "${PROMETHEUS_FOLDER_NAME}"

cd "${PROMETHEUS_FOLDER_NAME}"

rm -r console* LICENSE NOTICE
```

---
prometheus.yml (Server Config)
```
global:
  scrape_interval: 15s # Pull data every 15 seconds

scrape_configs:
- job_name: "prometheus" # Group targets (research, post-prod)
  static_configs:
  - targets:
    - localhost:9090 # local scrape. This is over HTTP
- job_name: "demo"
  static_configs:
  - targets:
    - demo.promlabs.com:1000 # Remote scrape
    - demo.promlabs.com:1001
    - demo.promlabs.com:1002
```

AWS
---

FSx Lustre on Centos 7 (3.10.0-1160.108.1.el7.x86_64)
```
curl https://fsx-lustre-client-repo-public-keys.s3.amazonaws.com/fsx-rpm-public-key.asc -o /tmp/fsx-rpm-public-key.asc
sudo rpm --import /tmp/fsx-rpm-public-key.asc
sudo curl https://fsx-lustre-client-repo.s3.amazonaws.com/el/7/fsx-lustre-client.repo -o /etc/yum.repos.d/aws-fsx.repo
sudo yum install -y kmod-lustre-client lustre-client
```

Docker
---

Give current user access to Docker
```
sudo usermod -aG docker $USER && newgrp docker
```

Clean docker runner
```
docker system prune -a
```

Check Docker image platform
```
docker image inspect busybox --format '{{ .Os }}/{{ .Architecture }}'
```

Linux
---

Generate new UUID for a drive
```bash
xfs_admin -U generate /dev/vdg
```

Find old ssh sessions and kill them
```
pstree -p
kill <NUMBER>
```

Finda a file
```
find / -name NAME
```

Check space in an easy to read way
```
du -h --max-depth=3 . | awk '$1 ~ /[0-9.]+G/ && $1+0 >= 5 {print}'
```

Check if TCP port is open
```
nc -zv 192.0.2.1 80
```
Check if UDP port is open
```
nc -zvu 192.0.2.1 123
```

Swap memory
```
sudo mkswap /dev/nvme1n1p1
sudo swapon /dev/nvme1n1p1
```

List UUID
```
lsblk -o NAME,UUID
```

List TCP network files
```
lsof -PiTCP
```

Show open ports
```
netstat -plunt
```

Find a string in directory
```
grep -rni "string" *
```

Send public key to a host  
```
ssh-copy-id -i ./key.pub <HOST>@<IP>
```

Check file size in directory
```
du -h --max-depth=1 .
```

format new drive (Prepare new EBS Volume added to EC2)
```
sudo fdisk /dev/nvme1n1

# n
# p
# 1
# ENTER
# w

sudo mkfs.ext4 /dev/nvme1n1p1
sudo mkdir -p /local
sudo mount /dev/nvme1n1p1 /local
sudo blkid /dev/nvme1n1p1
vi /etc/fstab
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /local defaults,nofail defaults 0 2
```

---
DCV Nice

Create session
```
dcv create-session --owner $user --user $user $(echo $user | tr -d '.')
```

List sessions
```
dcv list-sessions
```

Tailscale
---

Install
```
curl -fsSL https://tailscale.com/install.sh | sh

# Exit node
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
firewall-cmd --permanent --add-masquerade
sudo tailscale up --advertise-exit-node
```

nmap
---

Scan ports
```
nmap -Pn 10.20.9.174
```

Terraform
---

Change Version
```
terraform --version
tfenv list 
tfenv install 1.3.9
tfenv use 1.3.9
```

List resources
```
terraform state list
```

Remove resource from state
```
terraform state rm
```











