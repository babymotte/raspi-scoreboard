#!/bin/bash
echo "Stopping container …"
sudo docker stop scoreboard
echo "Deleting container …"
sudo docker container rm scoreboard
