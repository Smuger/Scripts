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



















