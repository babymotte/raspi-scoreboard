#!/bin/bash

# install docker
# TODO

# install node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

# install scoreboard
./start.sh
