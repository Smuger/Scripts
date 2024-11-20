Check certificate
---

https://www.sslshopper.com/ssl-checker.html

Kubernetes
---

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

format new drive
```
lsblk
fdisk /dev/nvme4n1
n
p
quit
1
w
sudo mkfs.ext4 /dev/nvme4n1
mount /dev/nvme4n1p1 /mount_point
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











