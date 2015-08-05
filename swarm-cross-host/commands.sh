# consul

docker-machine --debug create \
    -d virtualbox \
    --virtualbox-boot2docker-url="file:///home/shawn/chameleon-cloud-tutorial-docker-2/swarm-cross-host/boot2docker-1.8.iso" \
    consul

docker $(docker-machine config consul) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

# swarm token

export SWARM_TOKEN=$(docker run swarm create)

# swarm master

docker-machine --debug create \
    -d virtualbox \
    --virtualbox-boot2docker-url="file:///home/shawn/chameleon-cloud-tutorial-docker-2/swarm-cross-host/boot2docker-1.8.iso" \
    --engine-opt="default-network=overlay:multihost" \
    --engine-opt="kv-store=consul:$(docker-machine ip consul):8500" \
    --engine-label="com.docker.network.driver.overlay.bind_interface=eth0" \
    swarm-0

docker $(docker-machine config swarm-0) run -d \
    --restart="always" \
    --net="bridge" \
    swarm:latest join \
        --addr "$(docker-machine ip swarm-0):2376" \
        "token://$SWARM_TOKEN"

docker $(docker-machine config swarm-0) run -d \
    --restart="always" \
    --net="bridge" \
    -p "3376:3376" \
    -v "/etc/docker:/etc/docker" \
    swarm:latest manage \
        --tlsverify \
        --tlscacert="/etc/docker/ca.pem" \
        --tlscert="/etc/docker/cert.pem" \
        --tlskey="/etc/docker/key.pem" \
        -H "tcp://0.0.0.0:3376" \
        --strategy spread \
        "token://$SWARM_TOKEN"

# swarm nodes

docker-machine --debug create \
    -d virtualbox \
    --virtualbox-boot2docker-url="file:///home/shawn/chameleon-cloud-tutorial-docker-2/swarm-cross-host/boot2docker-1.8.iso" \
    --engine-opt="default-network=overlay:multihost" \
    --engine-opt="kv-store=consul:$(docker-machine ip consul):8500" \
    --engine-label="com.docker.network.driver.overlay.bind_interface=eth0" \
    --engine-label="com.docker.network.driver.overlay.neighbor_ip=$(docker-machine ip swarm-0)" \
    swarm-1

docker $(docker-machine config swarm-1) run -d \
    --restart="always" \
    --net="bridge" \
    swarm:latest join \
        --addr "$(docker-machine ip swarm-1):2376" \
        "token://$SWARM_TOKEN"
