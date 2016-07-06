#!/bin/bash

eval $(docker-machine env manager)
MANAGER_IP=$(docker-machine ip manager)
DOCKER_HOST=tcp://$(docker-machine ip manager):3376
echo "setting \$DOCKER_HOST to $MANAGER_IP:3376"
