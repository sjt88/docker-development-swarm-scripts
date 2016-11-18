docker-machine create -d virtualbox swarm-consul-0
docker-machine create -d virtualbox swarm-consul-1
docker-machine create -d virtualbox swarm-consul-2

export INTERNAL_IP=172.17.0.1

eval "$(docker-machine env swarm-consul-0)"
docker run -it -d --name consul \
-h $(docker-machine ip swarm-consul-0) \
-p $(docker-machine ip swarm-consul-0):8300:8300 \
-p $(docker-machine ip swarm-consul-0):8301:8301 \
-p $(docker-machine ip swarm-consul-0):8301:8301/udp \
-p $(docker-machine ip swarm-consul-0):8302:8302 \
-p $(docker-machine ip swarm-consul-0):8302:8302/udp \
-p $(docker-machine ip swarm-consul-0):8400:8400 \
-p $(docker-machine ip swarm-consul-0):8500:8500 \
-p $INTERNAL_IP:53:53 \
-p $INTERNAL_IP:53:53/udp \
-e swarm-CONSUL-0_BIND_INTERFACE=eth0 \
-e CONSUL_CLIENT_INTERFACE=eth0 \
consul agent -server -advertise $(docker-machine ip swarm-consul-0) -bootstrap-expect 3

eval "$(docker-machine env swarm-consul-1)"
docker run -it -d --name consul \
-h $(docker-machine ip swarm-consul-1) \
-p $(docker-machine ip swarm-consul-1):8300:8300 \
-p $(docker-machine ip swarm-consul-1):8301:8301 \
-p $(docker-machine ip swarm-consul-1):8301:8301/udp \
-p $(docker-machine ip swarm-consul-1):8302:8302 \
-p $(docker-machine ip swarm-consul-1):8302:8302/udp \
-p $(docker-machine ip swarm-consul-1):8400:8400 \
-p $(docker-machine ip swarm-consul-1):8500:8500 \
-p $INTERNAL_IP:53:53 \
-p $INTERNAL_IP:53:53/udp \
-e CONSUL_BIND_INTERFACE=eth0 \
-e CONSUL_CLIENT_INTERFACE=eth0 \
consul agent -server -retry-join $(docker-machine ip swarm-consul-0):8301 -advertise $(docker-machine ip swarm-consul-1)

eval "$(docker-machine env swarm-consul-2)"
docker run -it -d --name consul \
-h $(docker-machine ip swarm-consul-2) \
-p $(docker-machine ip swarm-consul-2):8300:8300 \
-p $(docker-machine ip swarm-consul-2):8301:8301 \
-p $(docker-machine ip swarm-consul-2):8301:8301/udp \
-p $(docker-machine ip swarm-consul-2):8302:8302 \
-p $(docker-machine ip swarm-consul-2):8302:8302/udp \
-p $(docker-machine ip swarm-consul-2):8400:8400 \
-p $(docker-machine ip swarm-consul-2):8500:8500 \
-p $INTERNAL_IP:53:53 \
-p $INTERNAL_IP:53:53/udp \
-e CONSUL_BIND_INTERFACE=eth0 \
-e CONSUL_CLIENT_INTERFACE=eth0 \
consul agent -server -retry-join $(docker-machine ip swarm-consul-0):8301 -advertise $(docker-machine ip swarm-consul-2)

export CONSUL_ADDR=consul://$(docker-machine ip swarm-consul-0):8500
export ENGINE_OPTS=
export SWARM_DISCOVERY_OPTS="--swarm-discovery $CONSUL_ADDR"

docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery $CONSUL_ADDR --engine-opt="cluster-store=$CONSUL_ADDR" --engine-opt="cluster-advertise=eth1:2376" swarm-master-0 \
  & docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery $CONSUL_ADDR --engine-opt="cluster-store=$CONSUL_ADDR" --engine-opt="cluster-advertise=eth1:2376" swarm-master-1 \
  & docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery $CONSUL_ADDR --engine-opt="cluster-store=$CONSUL_ADDR" --engine-opt="cluster-advertise=eth1:2376" swarm-master-2 \
  & docker-machine create -d virtualbox --swarm --swarm-discovery $CONSUL_ADDR --engine-opt="cluster-store=$CONSUL_ADDR" --engine-opt="cluster-advertise=eth1:2376" swarm-agent-0 \
  & docker-machine create -d virtualbox --swarm --swarm-discovery $CONSUL_ADDR --engine-opt="cluster-store=$CONSUL_ADDR" --engine-opt="cluster-advertise=eth1:2376" swarm-agent-1 \
  & docker-machine create -d virtualbox --swarm --swarm-discovery $CONSUL_ADDR --engine-opt="cluster-store=$CONSUL_ADDR" --engine-opt="cluster-advertise=eth1:2376" swarm-agent-2
wait

bash ./start_registry.sh

eval $(docker-machine env --swarm swarm-master-0)
docker info && echo "Swarm cluster created"
