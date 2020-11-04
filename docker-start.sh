#!/bin/bash
sudo service docker start
docker container stop $(docker container ls -aq)
docker-compose up --remove-orphans