export HOST_IP="123.123.123.123"
export HOSTNAME="testhost"
export CERTSD_FOLDER="testhost:5000"
export HOST_CERT_PATH="$(pwd)/test"

for machine_name in $(docker-machine ls | grep swarm- | awk '{print $1}'); do
  docker-machine ssh $machine_name "sudo mkdir /etc/docker/certs.d; sudo mkdir /etc/docker/certs.d/$CERTSD_FOLDER"
  docker-machine scp $HOST_CERT_PATH $machine_name:/home/docker/ca.crt
  docker-machine ssh $machine_name "sudo mv /home/docker/ca.crt /etc/docker/certs.d/$CERTSD_FOLDER/ca.crt"
  docker-machine ssh $machine_name "sudo cat /etc/hosts > /home/docker/hosts"
  docker-machine ssh $machine_name 'echo "$HOST_IP $HOSTNAME" >> /home/docker/hosts'
  docker-machine ssh $machine_name "sudo mv /home/docker/hosts /etc/hosts"
done
