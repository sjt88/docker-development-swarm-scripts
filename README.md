# Docker Development Swarm Scripts
A set of bash scripts for use with Docker Machine for creating & managing a docker swarm cluster for development/experimentation purposes.

---

## Prerequisites
Install Docker Engine & Docker Machine

--- 

## Create A Swarm Environment from scratch
```bash
bash create_docker_swarm.sh
```
Creates & starts a docker swarm environment for development purposes consisting of the following machines:
- consul - runs a `consul` container for docker engine networking & swarm discovery
- manager - runs `swarm manage` - single node swarm management cluster
- agent1 - runs `swarm join` container
- agent2 - runs `swarm join` container
- agent3 - runs `swarm join` container
- agent4 - runs `swarm join` container

The swarm will then be ready to use.

## Connect to the swarm manager
```bash
. ./set_docker_swarm_env.sh
```
any subsequent `docker` commands in the terminal session will then be executed on the swarm.

To easily switch back to your local docker daemon just use `docker-machine env -u`

## Create the swarm cluster containers
```bash
bash start_docker_swarm.sh
```
Creates the swarm cluster containers after they have been removed from their associated machines (with `stop_docker_swarm.sh`)

## Remove the swarm containers
```bash
bash stop_docker_swarm.sh
```
rm -f on consul/swarm containers on all the machines set up with `create_docker_swarm.sh`

## Remove the swarm machines
```bash
bash destroy_docker_swarm.sh
```
Removes all the machines created with create_docker_swarm.sh (complete tear down)

## Show the running containers on all machines
```bash
bash ps_docker_swarm.sh
```
outputs `docker ps -a` on all machines created with `create_docker_swarm.sh` (this is NOT the same as running `docker ps -a` when connected to a swarm manager!).
