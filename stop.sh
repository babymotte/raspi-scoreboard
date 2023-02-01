#!/bin/bash
echo "Stopping container …"
docker stop scoreboard
echo "Deleting container …"
docker container rm scoreboard
