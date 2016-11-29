echo "***********************************"
echo "    creating virtual machines      "
echo "***********************************"

echo "***********************************"
echo "    creating primary manager       "
echo "***********************************"
docker-machine create -d virtualbox manager1 \
  && echo "***********************************" \
  && echo "    creating manager 2             " \
  && echo "***********************************" \
  && docker-machine create -d virtualbox manager2 \
  && echo "***********************************" \
  && echo "    creating manager 3             " \
  && echo "***********************************" \
  && docker-machine create -d virtualbox manager3 \
  && echo "***********************************" \
  && echo "    creating worker 1              " \
  && echo "***********************************" \
  && docker-machine create -d virtualbox worker1 \
  && echo "***********************************" \
  && echo "    creating worker 2              " \
  && echo "***********************************" \
  && docker-machine create -d virtualbox worker2 \
  && echo "***********************************" \
  && echo "    creating worker 3              " \
  && echo "***********************************" \
  && docker-machine create -d virtualbox worker3 \
  && echo "***********************************" \
  && echo "      all machines created         " \
  && echo "***********************************" \
  && bash ./init_swarm.sh \
  && echo "Docker swarm is set up" \
  && exit

echo "Failed to create docker swarm :("
