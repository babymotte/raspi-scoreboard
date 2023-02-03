#!/bin/bash

# install docker
# TODO

# install node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

# install pihole
# TODO

# install unbound
suod apt-get -y install unbound
wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints
sudo cp ./unbound.cfg /etc/unbound/unbound.conf.d/pi-hole.conf
echo "edns-packet-max=1232" | sudo tee /etc/dnsmasq.d/99-edns.conf
sudo service unbound restart
sudo apt purge openresolv

# configure pihole to use unbound
# TODO

# install scoreboard
./start.sh

# set up local access point
# TODO

# enbale DHCP and DNS in pihole
# TODO

sudo reboot
