docker-machine rm $(docker-machine ls | grep "swarm-" | awk '{print $1}') registry -y \
&& echo 'All swarm machines deleted' \
&& exit

echo 'Failed to delete all swarm machines'
