# Chameleon Cloud Tutorial - Docker Machine, Compose, and Swarm

:warning: :warning: :warning:  
**Tutorial Under Development**

**Because of incompatibilities this tutorial doesn't currently use Chameleon resources. Instead you can use another cloud provider or local VM's. See [this](#setup-swarm-cluster) section for details.**

This tutorial will cover using Docker Machine, Compose and Swarm. In the first tutorial we setup containers on 2 different hosts and linked them together to run a simple webpage. In this tutorial we will set up a similar page that lets you post messages and lists those previously posted. It uses 3 containers and we'll arrange them with Compose.

Machine allows us to create Docker hosts and control them without interacting with the host machines directly. This way you don't have to SSH to machines running the Docker daemon to run containers.

Compose simplifies the process of arranging and linking containers together. Compose lets us specify the links and runtime configurations of containers in a single config file, rather than having several lengthy commands to execute in the right sequence.

Swarm is used to group multiple Docker hosts together so that containers or groups of containers can scale across machines.

Machine, Compose, and Swarm can be used together to simply and powerfully orchestrate a service. This is what we'll doing in this tutorial.

## Prerequisites

It's expected that you have gone through [Docker Tutorial 1](http://cloudandbigdatalab.github.io/docs/Chameleon%20Cloud%20Tutorial%20-%20Docker%20Fundamentals.pdf) or are already familiar with its content. No more prior knowledge is required past the first tutorial.

## Steps Outline

\# | Description | Time (mins)
---|-------------|------------
TBD

## Setup Swarm Cluster

**For this tutorial we're using a personal laptop and the Rackspace cloud.**

We're using a personal laptop because it's sensible to control remote machines from a local machine rather than SSH'ing to a remote machine to control remote machines. However, you can do all your work from a Chameleon instance. Every step is the same past installation, except you'll need to add `sudo` to your commands on the default Chameleon CentOS image.

We're using Rackspace because Machine doesn't currently support passing in reservation ids during host creation and therefore does not work with Chameleon. Support for Chameleon will likely happen in the future. See this [issue](https://github.com/docker/machine/issues/1461) on their GitHub.

### Installation

For this demo we used a personal MacBook running OS X but installation instructions are available for basically any OS. Here are the instructions for [Machine](https://docs.docker.com/machine/#installation) and [Compose](https://docs.docker.com/compose/install/). **If you're getting "Permission Denied" using curl, run `sudo -i` to become root, run the commands, then `exit`.**

**Experimental Docker Installation**

```shell
sudo -i
curl -L https://experimental.docker.com/builds/Darwin/x86_64/docker-latest > /usr/local/bin/docker
chmod +x /usr/local/bin/docker
exit
```

### Consul

```shell
docker-machine --debug create \
    -d rackspace \
    --engine-install-url="https://experimental.docker.com" \
    consul

docker $(docker-machine config consul) run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap
```

<script src="https://gist.github.com/shawnaten/2cb72e5811552fefe220.js"></script>

### Swarm Token

Create a machine. We're naming it `docker-main`. Point docker at the machine then generate a token. Save the token for later.

```shell
docker-machine --debug create \
    -d rackspace \
    --engine-install-url="https://experimental.docker.com" \
    docker-main

eval "$(docker-machine env docker-main)"

export SWARM_TOKEN=$(docker run swarm create)
```

### Swarm Master

Create the Swarm master.

```shell
docker-machine --debug create \
    -d rackspace \
    --rackspace-image-id="668b0764-4936-4eec-a2f2-3b5bb2c40b26" \
    --engine-install-url="https://experimental.docker.com" \
    --engine-opt="default-network=overlay:multihost" \
    --engine-opt="kv-store=consul:$(docker-machine ip consul):8500" \
    --engine-label="com.docker.network.driver.overlay.bind_interface=eth0" \
    swarm-0
```

### Startup Swarm
```shell
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
```

### Swarm Nodes

```shell

for((i=1;i<3;i++)); do \

docker-machine --debug create \
  -d rackspace \
  --rackspace-image-id="668b0764-4936-4eec-a2f2-3b5bb2c40b26" \
  --engine-install-url="https://experimental.docker.com" \
  --engine-opt="default-network=overlay:multihost" \
  --engine-opt="kv-store=consul:$(docker-machine ip consul):8500" \
  --engine-label="com.docker.network.driver.overlay.bind_interface=eth0" \
  --engine-label="com.docker.network.driver.overlay.neighbor_ip=$(docker-machine ip swarm-0)" \
  swarm-$i

docker $(docker-machine config swarm-$i) run -d \
  --restart="always" \
  --net="bridge" \
  swarm:latest join \
      --addr "$(docker-machine ip swarm-$i):2376" \
      "token://$SWARM_TOKEN"

done
```

### Point Docker at Swarm

```shell
export DOCKER_HOST=tcp://"$(docker-machine ip docker-swarm-master):3376"
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH="$HOME/.docker/machine/machines/docker-swarm-master"
```

You can see info about your swarm with `docker info`. The output should be similar to:

```shell

```

## Compose

Now we're going to launch our composition. Download the [docker-compose.yml](https://github.com/cloudandbigdatalab/chameleon-cloud-tutorial-docker-2/blob/master/docker-compose.yml) file from our repo. This lays out the 3 container composition.

Container Name | Apps | Description
----------|------|------------
server | Nginx | handles http requests
page | uWSGI and Django | uWSGI connects Nginx to Django, Django generates the html
db | Postgres | database for page, Django connects to Postgres

The Dockerfiles and code for the containers are in their respective folders. Note for the Postgres container we're using the unmodified image off Docker Hub so their isn't a folder for it.

## Run the Composition

`-p tutorial-2` specifies our project name. Otherwise the name of the directory would be used.

```shell
docker-compose -p tutorial-2 up -d
```

## Scale the Composition
