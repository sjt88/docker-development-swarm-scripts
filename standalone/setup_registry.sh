# sets up swarm machines to use an external docker registry
# - copies & installs registry ca cert
# - adds registry hostname/ip to machines hosts file
# 
# Usage:
# source registry_env.sh
# bash setup_registry.sh

for machine_name in $(docker-machine ls | grep swarm- | awk '{print $1}'); do
  docker-machine ssh $machine_name "sudo mkdir /etc/docker/certs.d; sudo mkdir /etc/docker/certs.d/$CERTSD_FOLDER"
  docker-machine scp $HOST_CERT_PATH $machine_name:/home/docker/ca.crt
  docker-machine ssh $machine_name "sudo mv /home/docker/ca.crt /etc/docker/certs.d/$CERTSD_FOLDER/ca.crt"
  docker-machine ssh $machine_name "sudo cat /etc/hosts > /home/docker/hosts"
  docker-machine ssh $machine_name 'echo "$HOST_IP $HOSTNAME" >> /home/docker/hosts'
  docker-machine ssh $machine_name "sudo mv /home/docker/hosts /etc/hosts"
done
