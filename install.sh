#!/bin/bash

sudo apt update && sudo apt -y full-upgrade && sudo apt install -y git && sudo apt autoremove || exit $?

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh && rm get-docker.sh || exit $?

# install node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) || exit $?
cd $HOME/.node-red &&
    npm install @babymotte/node-red-worterbuch &&
    npm install node-red-dashboard &&
    npm install node-red-node-pi-gpio &&
    cd projects && git clone https://github.com/babymotte/scoreboard-flow.git &&
    cd || exit $?
sudo systemctl start node-red || exit $?

# install dhcp
sudo apt-get install -y isc-dhcp-server || exit $?
echo "INTERFACESv4=\"wlan0\"" | sudo tee /etc/default/isc-dhcp-server || exit $?
sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf || exit $?
sudo systemctl start isc-dhcp-server || exit $?

# install dns
sudo apt install -y bind9 || exit $?
sudo cp ./named.conf.options /etc/bind/named.conf.options || exit $?
sudo cp ./named.conf.local /etc/bind/named.conf.local || exit $?
sudo cp ./forward.local /etc/bind/forward.local || exit $?
sudo systemctl restart bind9.service || exit $?

# install access point
sudo apt install -y hostapd || exit $?
sudo cp ./hostapd.conf /etc/hostapd/hostapd.conf || exit $?
sudo chmod 600 /etc/hostapd/hostapd.conf || exit $?
sudo cp ./hostapd.default /etc/default/hostapd || exit $?
sudo systemctl unmask hostapd || exit $?
sudo systemctl enable --now hostapd || exit $?

# install scoreboard
./start.sh || exit $?

# static ip
sudo cp ./wlan0.static /etc/network/interfaces.d/wlan0.conf || exit $?

sudo reboot
