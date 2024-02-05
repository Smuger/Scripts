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


Linux
---

Swap memory
```
sudo mkswap /dev/nvme1n1p1
sudo swapon /dev/nvme1n1p1
```

List UUID
```
lsblk -o NAME,UUID
```

Show open ports
```
sudo lsof -i -n
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
lsblk -fl
sudo parted /dev/sdX
print
mkpart primary ex4 startByte endByte
quit
sudo mkfs.ext4 -F /dev/sdXY 
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


Github
---

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













