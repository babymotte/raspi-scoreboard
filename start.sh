#!/bin/bash
sudo docker run --restart always -p 80:80 -v $(pwd)/config.js:/app/html/__config__.js --name scoreboard --detach babymotte/scoreboard-worterbuch-arm:latest
