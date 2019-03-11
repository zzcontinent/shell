#!/bin/sh
sudo docker start master &&
sudo docker exec -it master bash -c "hostname master && su - hadoop"
