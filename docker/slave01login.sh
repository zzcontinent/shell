#!/bin/sh
sudo docker start slave01 &&
sudo docker exec -it slave01 bash -c "hostname slave01 && su - hadoop"
