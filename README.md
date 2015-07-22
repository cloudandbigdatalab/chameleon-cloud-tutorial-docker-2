# Chameleon Cloud Tutorial - Docker Machine, Compose, and Swarm

:warning: :warning: :warning:  
**Tutorial Under Development**

This tutorial will cover using Docker Machine, Compose and Swarm. In the first tutorial we setup containers on 2 different hosts and linked them together to run a simple webpage. In this tutorial we will set up a similar page that lets you post messages and lists those previously posted. It uses 3 containers and we'll arrange them with Compose.

Machine allows us to create Docker hosts and control them without interacting with the host machines directly. This way you don't have to SSH to machines running the Docker daemon to run containers.

Compose simplifies the process of arranging and linking containers together. Compose lets us specify the links and runtime configurations of containers in a single config file, rather than having several lengthy commands to execute in the right sequence.

Swarm is used to group multiple Docker hosts together so that containers or groups of containers can scale across machines.

Machine, Compose, and Swarm can be used together to simply and powerfully orchestrate a service. This is what we'll doing in this tutorial.

## Prerequisites

It's expected that you have gone through the [first Docker tutorial](http://cloudandbigdatalab.github.io/docs/Chameleon%20Cloud%20Tutorial%20-%20Docker%20Fundamentals.pdf) or are already familiar with its content. No more prior knowledge is required past the first tutorial. This tutorial uses a Chameleon baremetal machine running CentOS 7.

## Steps Outline

\# | Description | Time (mins)
---|-------------|------------
TBD

## Installation

For this demo we used a personal MacBook running OS X to launch and control hosts and containers. The installation and commands are very similar for other OS though, including CentOS on Chameleon. Here are the installation instructions for [Machine](https://docs.docker.com/machine/#installation) and [Compose](https://docs.docker.com/compose/install/). Follow the steps for your OS. **If you're getting "Permission Denied" using curl run `sudo -i` to become root, run the commands, then `exit`.**

## Setup Swarm Cluster

**For this tutorial we're using the Rackspace cloud.** We're doing this because Machine doesn't currently support passing in reservation ids during host creation and therefore does not work with Chameleon. Support for Chameleon will likely happen in the future. See this [issue](https://github.com/docker/machine/issues/1461) on their GitHub.

### Swarm Token

Create a machine. We're naming it *docker-main*.

```bash
docker-machine create \
  -d rackspace \
  --rackspace-username $USERNAME \
  --rackspace-api-key $API_KEY \
  --rackspace-region $REGION \
  docker-main
```

Load the machine env variables.

```bash
eval "$(docker-machine env docker-main)"
```

Generate a token. Save the token for later. You can set it as env variable if you'd like.

```bash
docker run swarm create
```

### Swarm Master

Create the Swarm master.

```bash
docker-machine create \
  -d rackspace \
  --rackspace-username $USERNAME \
  --rackspace-api-key $API_KEY \
  --rackspace-region $REGION \
  --swarm \
  --swarm-master \
  --swarm-discovery token://$TOKEN \
  swarm-master
```

### Swarm Nodes

We're using a bash loop to create 2 swarm nodes. You can create as many as you want. (Creating 2 on Rackspace took about 3 minutes.)

```bash
for((i=0;i<2;i++)); do \
  docker-machine create \
    -d rackspace \
    --rackspace-username $USERNAME \
    --rackspace-api-key $API_KEY \
    --rackspace-region $REGION \
    --swarm \
    --swarm-discovery token://$TOKEN \
    swarm-node-$i; \
done
```

Now if we run `docker-machine ls` we should see something like:

```bash
NAME           ACTIVE   DRIVER       STATE     URL                          SWARM
dev                     virtualbox   Stopped
docker-main    *        rackspace    Running   tcp://23.253.119.45:2376
swarm-master            rackspace    Running   tcp://23.253.107.53:2376     swarm-master (master)
swarm-node-0            rackspace    Running   tcp://23.253.90.169:2376     swarm-master
swarm-node-1            rackspace    Running   tcp://104.239.132.168:2376   swarm-master
```

You can ignore the *dev* machine.

## Compose

### Containers in Composition

Level | Name | Apps Running
------|------|------------
1 | http_server | Nginx
2 | page_generator | uWSGI, Django
2 | image_processor | uWSGI, Django, OpenCV

The http_server container will act as the front for both the page_generator and image_processor containers. I think this way I can also set up the image_processor first and test it without the webpage.
