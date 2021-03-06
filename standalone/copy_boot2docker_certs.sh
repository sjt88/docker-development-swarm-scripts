#! /bin/bash

# copies all of the certs generated by docker-machine into /home/docker/certs on each machine
# renames the files so they can be used with DOCKER_CERT_PATH to connect to swarm manager

export MAKEDIR="mkdir /home/docker/certs"
export COPY_CA="cp /var/lib/boot2docker/ca.pem /home/docker/certs/ca.pem"
export COPY_CERT="cp /var/lib/boot2docker/server.pem /home/docker/certs/cert.pem"
export COPY_KEY="cp /var/lib/boot2docker/server-key.pem /home/docker/certs/key.pem"

for machine_name in $(docker-machine ls | grep swarm- | awk '{print $1}'); do
	docker-machine ssh $machine_name $MAKEDIR
	docker-machine ssh $machine_name $COPY_CA
	docker-machine ssh $machine_name $COPY_CERT
	docker-machine ssh $machine_name $COPY_KEY
done
