echo "***********************************"
echo "    initialising primary manager   "
echo "***********************************"

eval $(docker-machine env manager1)

SWARM_PRIMARY_MANAGER_IP=$(docker-machine ip manager1)
docker swarm init --advertise-addr $SWARM_PRIMARY_MANAGER_IP
SWARM_MANAGER_JOIN_TOKEN="$(docker swarm join-token manager --quiet)"
SWARM_AGENT_JOIN_TOKEN="$(docker swarm join-token worker --quiet)"

echo "***********************************"
echo "    joining managers to swarm      "
echo "***********************************"

eval $(docker-machine env manager2)                                                \
  && docker swarm join --token $SWARM_MANAGER_JOIN_TOKEN $SWARM_PRIMARY_MANAGER_IP \
  && eval $(docker-machine env manager3)                                           \
  && docker swarm join --token $SWARM_MANAGER_JOIN_TOKEN $SWARM_PRIMARY_MANAGER_IP \
  && echo "***********************************"                                    \
  && echo "     joining workers to swarm      "                                    \
  && echo "***********************************"                                    \
  && eval $(docker-machine env worker1)                                            \
  && docker swarm join --token $SWARM_AGENT_JOIN_TOKEN $SWARM_PRIMARY_MANAGER_IP   \
  && eval $(docker-machine env worker2)                                            \
  && docker swarm join --token $SWARM_AGENT_JOIN_TOKEN $SWARM_PRIMARY_MANAGER_IP   \
  && eval $(docker-machine env worker3)                                            \
  && docker swarm join --token $SWARM_AGENT_JOIN_TOKEN $SWARM_PRIMARY_MANAGER_IP   \
  && echo "***********************************" \
  && echo "    connecting to swarm manager    " \
  && echo "***********************************" \
  && eval $(docker-machine env manager1)
