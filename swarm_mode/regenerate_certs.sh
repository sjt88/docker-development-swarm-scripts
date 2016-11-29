MACHINE_NAMES=$(docker-machine ls | grep "manager\|worker" | awk '{printf " %s", $1}')
docker-machine regenerate-certs $MACHINE_NAMES