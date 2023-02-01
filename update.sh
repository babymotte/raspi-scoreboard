#!/bin/bash
./stop.sh
echo "Pulling latest image …"
docker pull babymotte/scoreboard-worterbuch-arm:latest
echo "Recreating container …"
./start.sh
