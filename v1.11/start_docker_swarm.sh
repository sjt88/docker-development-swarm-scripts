#!/bin/bash
export INTERNAL_IP=172.17.0.1

eval $(docker-machine env consul)
export CONSUL_IP=$(docker-machine ip consul)

docker run -it -d --name consul \
-h $CONSUL_IP \
-p $CONSUL_IP:8300:8300 \
-p $CONSUL_IP:8301:8301 \
-p $CONSUL_IP:8301:8301/udp \
-p $CONSUL_IP:8302:8302 \
-p $CONSUL_IP:8302:8302/udp \
-p $CONSUL_IP:8400:8400 \
-p $CONSUL_IP:8500:8500 \
-p $INTERNAL_IP:53:53 \
-p $INTERNAL_IP:53:53/udp \
-e CONSUL_BIND_INTERFACE=eth0 \
-e CONSUL_CLIENT_INTERFACE=eth0 \
consul agent -server -bootstrap

# start manager
eval $(docker-machine env manager)
export MANAGER_IP=$(docker-machine ip manager)
export DISCOVERY_URL=consul://$CONSUL_IP:8500

docker run -d --name swarm_manager \
-p 3376:3376 \
-v /var/lib/boot2docker:/certs:ro \
swarm manage -H 0.0.0.0:3376 \
--tlsverify \
--tlscacert=/certs/ca.pem \
--tlscert=/certs/server.pem \
--tlskey=/certs/server-key.pem \
--advertise=$MANAGER_IP:3376 $DISCOVERY_URL

# start agents
eval $(docker-machine env agent1) && docker run -d --name swarm_agent swarm join --advertise=$(docker-machine ip agent1):2376 $DISCOVERY_URL &
eval $(docker-machine env agent2) && docker run -d --name swarm_agent swarm join --advertise=$(docker-machine ip agent2):2376 $DISCOVERY_URL &
eval $(docker-machine env agent3) && docker run -d --name swarm_agent swarm join --advertise=$(docker-machine ip agent3):2376 $DISCOVERY_URL &
eval $(docker-machine env agent4) && docker run -d --name swarm_agent swarm join --advertise=$(docker-machine ip agent4):2376 $DISCOVERY_URL
wait
echo "Swarm is running - manager available on: $MANAGER_IP:3376"
echo "Run `bash set_docker_swarm_env.sh` to connect your docker engine to the swarm manager "