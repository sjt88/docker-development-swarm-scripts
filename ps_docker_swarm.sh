#!/bin/bash

echo *****"**** consul *********"
eval $(docker-machine env consul) && docker ps -a
echo "**************************"

echo *****"**** manager *********"
eval $(docker-machine env manager) && docker ps -a
echo "**************************"

echo *****"**** agent1 *********"
eval $(docker-machine env agent1) && docker ps -a
echo "**************************"

echo *****"**** agent2 *********"
eval $(docker-machine env agent2) && docker ps -a
echo "**************************"

echo *****"**** agent3 *********"
eval $(docker-machine env agent3) && docker ps -a
echo "**************************"

echo *****"**** agent3 *********"
eval $(docker-machine env agent4) && docker ps -a
echo "**************************"
