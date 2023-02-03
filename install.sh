#!/bin/bash

sudo apt update && sudo apt -y full-upgrade && sudo apt autoremove

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && rm get-docker.sh

# install node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

# install dhcp
sudo apt-get install -y isc-dhcp-server
echo "INTERFACESv4=\"wlan0\"" | sudo tee /etc/default/isc-dhcp-server
sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf
sudo systemctl start isc-dhcp-server

# install dns
sudo apt install -y bind9
sudo cp ./named.conf.options /etc/bind/named.conf.options
sudo cp ./named.conf.local /etc/bind/named.conf.local
sudo cp ./forward.local /etc/bind/forward.local
sudo systemctl restart bind9.service

# install access point
sudo apt install -y hostapd
sudo cp ./hostapd.conf /etc/hostapd/hostapd.conf
sudo chmod 600 /etc/hostapd/hostapd.conf

# install scoreboard
./start.sh

# static ip
sudo cp ./wlan0.static /etc/network/interfaces.d/wlan0.conf

sudo reboot
