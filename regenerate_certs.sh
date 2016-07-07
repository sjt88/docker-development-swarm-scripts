#!/bin/bash

docker-machine regenerate-certs \
consul \
manager \
agent1 \
agent2 \
agent3 \
agent4
echo "All certificates regenerated!"
