docker-machine create -d virtualbox consul
export CONSUL_IP=$(docker-machine ip consul)
docker-machine create -d virtualbox --engine-opt="cluster-store=consul://$CONSUL_IP:8500" --engine-opt="cluster-advertise=eth1:2376" manager &
docker-machine create -d virtualbox --engine-opt="cluster-store=consul://$CONSUL_IP:8500" --engine-opt="cluster-advertise=eth1:2376" agent1 &
docker-machine create -d virtualbox --engine-opt="cluster-store=consul://$CONSUL_IP:8500" --engine-opt="cluster-advertise=eth1:2376" agent2 &
docker-machine create -d virtualbox --engine-opt="cluster-store=consul://$CONSUL_IP:8500" --engine-opt="cluster-advertise=eth1:2376" agent3 &
docker-machine create -d virtualbox --engine-opt="cluster-store=consul://$CONSUL_IP:8500" --engine-opt="cluster-advertise=eth1:2376" agent4
wait

bash start_docker_swarm.sh
echo "done"
