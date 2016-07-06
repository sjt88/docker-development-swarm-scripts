#!/bin/bash

echo "deleting consul"
eval $(docker-machine env consul)
docker rm -f $(docker ps -a | grep "consul" | awk '{print $1}')
echo "successfully deleted consul"

echo "deleting manager"
eval $(docker-machine env manager)
docker rm -f $(docker ps -a | grep "swarm" | awk '{print $1}')
echo "successfully deleted manager"

echo "deleting agent1"
eval $(docker-machine env agent1)
docker rm -f $(docker ps -a | grep "swarm" | awk '{print $1}')
echo "successfully deleted agent1"

echo "deleting agent2"
eval $(docker-machine env agent2)
docker rm -f $(docker ps -a | grep "swarm" | awk '{print $1}')
echo "successfully deleted agent2"

echo "deleting agent3"
eval $(docker-machine env agent3)
docker rm -f $(docker ps -a | grep "swarm" | awk '{print $1}')
echo "successfully deleted agent3"

echo "deleting agent4"
eval $(docker-machine env agent4)
docker rm -f $(docker ps -a | grep "swarm" | awk '{print $1}')
echo "successfully deleted agent4"

echo "all swarm containers deleted"
