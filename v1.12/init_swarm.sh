echo "***********************************"
echo "       initialising manager        "
echo "***********************************"

eval $(docker-machine env manager1)
docker swarm init --advertise-addr $(docker-machine ip manager1)


echo "***********************************"
echo "     joining workers to swarm      "
echo "***********************************"
export DOCKERSWARM_JOIN_TOKEN="$(docker swarm join-token worker --quiet)"

eval $(docker-machine env worker1)             \
	&& echo "docker swarm join --token $DOCKERSWARM_JOIN_TOKEN $(docker-machine ip manager1):2377"\
	&& eval $(docker-machine env worker2)        \
	&& docker swarm join --token $DOCKERSWARM_JOIN_TOKEN $(docker-machine ip manager1):2377 \
	&& eval $(docker-machine env worker3)        \
	&& docker swarm join --token $DOCKERSWARM_JOIN_TOKEN $(docker-machine ip manager1):2377 \
	&& eval $(docker-machine env manager1)       \
	&& echo "***********************************"\
	&& echo "    connected to swarm manager     "\
	&& echo "***********************************"\
	&& exit

echo "Failed to set up swarm :("