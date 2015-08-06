docker-machine create \
    -d rackspace \
    --engine-install-url="https://experimental.docker.com" \
    docker-main

eval "$(docker-machine env docker-main)"

export SWARM_TOKEN=$(docker run swarm create)

docker-machine create \
    -d rackspace \
    --engine-install-url="https://experimental.docker.com" \
    consul

docker $(docker-machine config consul) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

docker-machine create \
    -d rackspace \
    --rackspace-image-id="668b0764-4936-4eec-a2f2-3b5bb2c40b26" \
    --engine-install-url="https://experimental.docker.com" \
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
        --tlscert="/etc/docker/server.pem" \
        --tlskey="/etc/docker/server-key.pem" \
        -H "tcp://0.0.0.0:3376" \
        --strategy spread \
        "token://$SWARM_TOKEN"

docker-machine create \
    -d rackspace \
    --rackspace-image-id="668b0764-4936-4eec-a2f2-3b5bb2c40b26" \
    --engine-install-url="https://experimental.docker.com" \
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

export DOCKER_HOST=tcp://"$(docker-machine ip swarm-0):3376"
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH="$HOME/.docker/machine/machines/swarm-0"
