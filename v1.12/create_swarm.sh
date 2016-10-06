echo "***********************************"
echo "    creating virtual machines      "
echo "***********************************"
docker-machine create -d virtualbox manager1 \
	& docker-machine create -d virtualbox worker1  \
	& docker-machine create -d virtualbox worker2  \
	& docker-machine create -d virtualbox worker3
wait

bash ./init_swarm.sh
