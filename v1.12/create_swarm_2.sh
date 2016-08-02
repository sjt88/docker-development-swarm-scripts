echo "***********************************"
echo "    creating virtual machines      "
echo "***********************************"
docker-machine create -d virtualbox manager1 \
& docker-machine create -d virtualbox manager2 \
& docker-machine create -d virtualbox manager3 \
& docker-machine create -d virtualbox worker1 \
& docker-machine create -d virtualbox worker2 \
& docker-machine create -d virtualbox worker3 \
& docker-machine create -d virtualbox worker4 \
& docker-machine create -d virtualbox worker5

echo "***********************************"
echo "       initialising manager        "
echo "***********************************"
docker-machine ssh manager1 "docker swarm init --advertise-addr $(docker-machine ip manager1)"

echo "***********************************"
echo "     joining workers to swarm      "
echo "***********************************"
export DOCKERSWARM_MANAGER_JOIN_CMD="$(docker-machine ssh manager1 docker swarm join-token manager | sed -n '2,4p')"
docker-machine ssh manager1 "$DOCKERSWARM_MANAGER_JOIN_CMD"
docker-machine ssh manager2 "$DOCKERSWARM_MANAGER_JOIN_CMD"
docker-machine ssh manager3 "$DOCKERSWARM_MANAGER_JOIN_CMD"

export DOCKERSWARM_WORKER_JOIN_CMD="$(docker-machine ssh manager1 docker swarm join-token worker | sed -n '2,4p')"
docker-machine ssh worker1 "$DOCKERSWARM_WORKER_JOIN_CMD"
docker-machine ssh worker2 "$DOCKERSWARM_WORKER_JOIN_CMD"
docker-machine ssh worker3 "$DOCKERSWARM_WORKER_JOIN_CMD"
docker-machine ssh worker4 "$DOCKERSWARM_WORKER_JOIN_CMD"
docker-machine ssh worker5 "$DOCKERSWARM_WORKER_JOIN_CMD"

eval $(docker-machine env manager1)
echo "***********************************"
echo "    connected to swarm manager     "
echo "***********************************"