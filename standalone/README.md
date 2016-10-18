# Standalone docker swarm
Use these scripts to set up a swarm environment using standalone docker swarm containers (not swarm mode available in 1.12 & later).

## Prerequisites
Install Docker Engine & Docker Machine

## Usage

### Create
```bash
bash create_docker_swarm.sh
```

This will create machines with the following names:

consul server cluster
These each run a single consul server & are used for docker networking & swarm container discovery
- swarm-consul-0
- swarm-consul-1
- swarm-consul-2

swarm management cluster
You can connect to any of these to manage the swarm cluster
- swarm-master-0
- swarm-master-1
- swarm-master-2

swarm agents/workers
Your swarm will run containers on these machines
- swarm-agent-0
- swarm-agent-1
- swarm-agent-2

secure docker registry
You can push images here so they are available to all swarm agents
- registry

Once the script has finished you will be instructed to copy the ca certificate for your registry to /etc/docker/certs.d for your host engine. If you wish to use the registry you must follow this step, or you will be unable to push to it.

You can manage the swarm by doing the following:
```bash
eval $(docker-machine env --swarm swarm-master-0)
```
All subsequent docker commands will then be run on the swarm.

### Remove swarm machines
bash destroy_docker_swarm.sh

### Create & start registry only
```bash
bash start_registry.sh
```

### Regenerate certificates
Sometimes it is neccessary to regenerate certificates for all the docker machines if they are restarted & assigned different IPs. The following script will do this for you on all swarm related machines.
```bash
bash regenerate_certs.sh
```

## Basic registry usage
### Push an image to your registry
Using nginx image available on dockerhub as an example
```bash
docker tag nginx $(docker-machine ip registry):5000/nginx
docker push $(docker-machine ip registry):5000/nginx
```

### Pull an image to all swarm nodes
```bash
eval $(docker-machine env --swarm swarm-master-0)
docker pull $(docker-machine ip registry):5000/nginx
```
