# sets up swarm machines to use an external docker registry
# deploys registry ca file to all swarm machines
#


export REGISTRY_IP="$(docker-machine ip registry):5000"

for machine_name in $(docker-machine ls | grep swarm- | awk '{print $1}'); do
  docker-machine ssh $machine_name "sudo mkdir /etc/docker/certs.d; sudo mkdir /etc/docker/certs.d/$REGISTRY_IP"
  docker-machine scp ./registry/ca/ca.pem $machine_name:/home/docker/ca.crt
  docker-machine ssh $machine_name "sudo mv /home/docker/ca.crt /etc/docker/certs.d/$REGISTRY_IP/ca.crt"
  docker-machine ssh $machine_name "sudo cat /etc/hosts > /home/docker/hosts"
  docker-machine ssh $machine_name "sudo mv /home/docker/hosts /etc/hosts"
done
