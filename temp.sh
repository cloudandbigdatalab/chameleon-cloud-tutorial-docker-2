docker-machine create -d digitalocean --swarm \
  --swarm-discovery=token://$SWARM_TOKEN docker-swarm-node-0

docker-machine create -d rackspace --swarm \
  --swarm-discovery=token://$SWARM_TOKEN docker-swarm-node-1

docker-machine --debug create \
  -d digitalocean \
  --digitalocean-image="ubuntu-15-04-x64" \
  --engine-install-url="https://experimental.docker.com" \
  --engine-opt="default-network=overlay:multihost" \
  --engine-opt="kv-store=consul:$(docker-machine ip consul):8500" \
  --engine-label="com.docker.network.driver.overlay.bind_interface=eth0" \
  swarm-0
