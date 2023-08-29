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

echo -e "${warn}[Gitlab]${no} : ${cyan}Установка...${no}"

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash

apt update && apt install -y \
    curl \
    make \
    perl \
    htop \
    gitlab-ce \
    openssh-server \
    ca-certificates

sed -i "s!external_url 'http://gitlab.example.com'!external_url 'http://$1'!1" /etc/gitlab/gitlab.rb

sed -i "s!gitlab_rails['registry_enabled'] = true!In the bottom!1" /etc/gitlab/gitlab.rb
sed -i "s!registry_external_url 'https://registry.example.com'!In the bottom!1" /etc/gitlab/gitlab.rb
sed -i "s!registry_nginx['enable'] = false!In the bottom!1" /etc/gitlab/gitlab.rb
sed -i "s!registry_nginx['proxy_set_headers'] = {! !1" /etc/gitlab/gitlab.rb
sed -i 's!"Host" => "$http_host",! !1' /etc/gitlab/gitlab.rb
sed -i 's!"X-Real-IP" => "$remote_addr",! !1' /etc/gitlab/gitlab.rb
sed -i 's!"X-Forwarded-For" => "$proxy_add_x_forwarded_for",! !1' /etc/gitlab/gitlab.rb
sed -i 's!"X-Forwarded-Proto" => "https",! !1' /etc/gitlab/gitlab.rb
sed -i 's!"X-Forwarded-Ssl" => "on"! !1' /etc/gitlab/gitlab.rb
sed -i "s!registry_nginx['listen_port'] = 5050!In the bottom!1" /etc/gitlab/gitlab.rb


echo "gitlab_rails['registry_enabled'] = true" >> /etc/gitlab/gitlab.rb
echo "registry_external_url 'http://registry.$1'" >> /etc/gitlab/gitlab.rb
echo "registry_nginx['enable'] = true" >> /etc/gitlab/gitlab.rb
echo "registry_nginx['proxy_set_headers'] = {" >> /etc/gitlab/gitlab.rb
echo '  "Host" => "$http_host",' >> /etc/gitlab/gitlab.rb
echo '  "X-Real-IP" => "$remote_addr",' >> /etc/gitlab/gitlab.rb
echo '  "X-Forwarded-For" => "$proxy_add_x_forwarded_for",' >> /etc/gitlab/gitlab.rb
echo '  "X-Forwarded-Proto" => "http",' >> /etc/gitlab/gitlab.rb
echo '  "X-Forwarded-Ssl" => "off"' >> /etc/gitlab/gitlab.rb
echo "}" >> /etc/gitlab/gitlab.rb
echo "registry_nginx['listen_port'] = 5050" >> /etc/gitlab/gitlab.rb
echo "registry_nginx['listen_https'] = false" >> /etc/gitlab/gitlab.rb

gitlab-ctl reconfigure

gitlab-ctl restart

su - vagrant -c "sudo cat /etc/gitlab/initial_root_password | grep Password: | sed -r 's/.{,10}//' > ~/gitlab.passwd"

echo -e "${warn}[k8s installer]${no} ${cyan}Установка mkcert для самоподписных сертификатов${no}"
curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest| grep browser_download_url  | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
mv mkcert-v*-linux-amd64 mkcert
chmod a+x mkcert
mv mkcert /usr/local/bin/
