#!/bin/bash
no='\033[0m'		# Color Reset
ok='\033[32;01m'    # Green Ok
err='\033[31;01m'	# Error red
warn='\033[1;33m'   # Yellow
blue='\033[1;34m'   # Blue
purp='\033[1;35m'   # Purple
cyan='\033[1;36m'   # Cyan
white='\033[1;37m'  # White

echo -e "${warn}[Node Exporter]${no} : ${cyan}Загрузка...${no}"
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
echo -e "${warn}[Node Exporter]${no} : ${ok}...успешно загружено${no}"

echo -e "${warn}[Node Exporter]${no} : ${cyan}Установка...${no}"
tar xvfz node_exporter-*.linux-amd64.tar.gz
cd node_exporter-*.*-amd64
sudo mv node_exporter /usr/bin/

echo -e "${warn}[Node Exporter]${no} : ${cyan}Создание пользователя...${no}"
sudo useradd -r -M -s /bin/false node_exporter
sudo chown node_exporter:node_exporter /usr/bin/node_exporter

echo -e "${warn}[Node Exporter]${no} : ${cyan}Создание системного юнита...${no}"
{   echo '[Unit]'; \
    echo 'Description=Prometheus Node Exporter'; \
    echo '[Service]'; \
    echo 'User=node_exporter'; \
    echo 'Group=node_exporter'; \
    echo 'Type=simple'; \
    echo 'ExecStart=/usr/bin/node_exporter'; \
    echo '[Install]'; \
    echo 'WantedBy=multi-user.target'; \
} | tee /etc/systemd/system/node_exporter.service;

echo -e "${warn}[Runner]${no} : ${cyan}Установка...${no}"

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

apt update && apt install -y \
    make \
    curl \
    htop \
    docker \
    gitlab-runner \
    docker-compose

echo -e "${warn}[k8s installer]${no} ${cyan}Установка mkcert для самоподписных сертификатов${no}"
curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest| grep browser_download_url  | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
mv mkcert-v*-linux-amd64 mkcert
chmod a+x mkcert
mv mkcert /usr/local/bin/

echo -e "${warn}[Docker]${no} : ${cyan}Добавление пользователя в группу Docker...${no}"

usermod -aG docker vagrant

groups vagrant
