#!/bin/bash

[[ ! -f $HOME/.firstrun ]] && {
    echo "A full system update needs to be done before the installation can continue. Press ENTER to update the system now."
    read SOMETHING
    sudo apt update && sudo apt -y full-upgrade --fix-missing || exit $?
    touch $HOME/.firstrun
    echo "System updated successfully. System will now reboot. Once back up, run the install script again. Press ENTER to continue."
    read SOMETHING
    sudo reboot
}

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh &&
    sudo sh get-docker.sh &&
    rm get-docker.sh &&
    sudo systemctl enable --now docker ||
    exit $?

# install node-red
DIR=$(pwd)
curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered >node-setup.sh &&
    bash node-setup.sh --confirm-install --confirm-pi --restart --update-nodes &&
    rm node-setup.sh &&
    cd $HOME/.node-red &&
    npm install @babymotte/node-red-worterbuch &&
    npm install node-red-dashboard &&
    npm install node-red-node-pi-gpio &&
    mkdir projects && cd projects && git clone https://github.com/babymotte/scoreboard-flow.git &&
    sudo systemctl enable nodered &&
    cd "$DIR" || exit $?

# install dhcp
sudo apt-get install -y isc-dhcp-server &&
    echo "INTERFACESv4=\"wlan0\"" | sudo tee /etc/default/isc-dhcp-server &&
    sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf || exit $?

# install dns
sudo apt install -y bind9 &&
    sudo cp ./named.conf.options /etc/bind/named.conf.options &&
    sudo cp ./named.conf.local /etc/bind/named.conf.local &&
    sudo cp ./forward.local /etc/bind/forward.local || exit $?

# install access point
sudo apt install -y hostapd &&
    sudo cp ./hostapd.conf /etc/hostapd/hostapd.conf &&
    sudo cp ./hostapd.default /etc/default/hostapd &&
    sudo systemctl unmask hostapd &&
    sudo systemctl enable hostapd || exit $?

# install scoreboard
./start.sh || exit $?

# clean up
sudo apt -y autoremove

# static ip
sudo systemctl disable wpa_supplicant.service &&
    sudo systemctl disable dhcpcd.service &&
    sudo cp ./wlan0.conf /etc/network/interfaces.d/wlan0.conf || exit $?

# autostart
sudo cp ./xinitrc /root/.xinitrc &&
    echo "[Unit]
Description=Score Board
After=network.target

[Service]
Type=simple
ExecStart=$(pwd)/scoreboard.sh

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/scoreboard.service &&
    sudo systemctl daemon-reload &&
    sudo systemctl enable scoreboard.service || exit $?

# done
sudo reboot
