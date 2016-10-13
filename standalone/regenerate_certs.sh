for machine_name in $(docker-machine ls | grep swarm- | awk '{print $1}'); do
	docker-machine regenerate-certs $machine_name
done
