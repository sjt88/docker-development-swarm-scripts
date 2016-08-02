echo "***********************************"
echo "    creating virtual machines      "
echo "***********************************"
docker-machine create -d virtualbox manager1 &
docker-machine create -d virtualbox worker1 &
docker-machine create -d virtualbox worker2

echo "***********************************"
echo "       initialising manager        "
echo "***********************************"
docker-machine ssh manager1 docker swarm init --advertise-addr $(docker-machine ip manager1)

echo "***********************************"
echo "     joining workers to swarm      "
echo "***********************************"
eval "$(docker-machine ssh manager1 docker swarm join-token worker | sed -n '2,4p')"
