#!/bin/bash

# install docker
# TODO

# install node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

# config dhcpcd
sudo cp ./dhcpcd.conf /etc/dhcpcd.conf

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

sudo reboot
