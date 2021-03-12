#!/bin/sh
sudo docker start slave02 &&
sudo docker exec -it slave02 bash -c "hostname slave02 && su - hadoop"
