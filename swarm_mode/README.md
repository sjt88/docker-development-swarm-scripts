#### Create a 6 machine swarm mode cluster
This will create 6 machines then run the `init_swarm.sh` script to set up the swarm cluster automatically
```text
bash create_swarm.sh
```

The machines will be named as follows:
- manager1
- manager2
- manager3
- worker1
- worker2
- worker3

#### Remove all swarm machines
```text
bash remove_swarm.sh
```

#### Regenerate certificates on all machines
```text
bash regenerate_certs.sh
```
