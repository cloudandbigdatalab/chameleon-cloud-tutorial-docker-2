# Chameleon Cloud Tutorial - Docker Machine, Compose, and Swarm

:warning: :warning: :warning:  
**Tutorial Under Development**

This tutorial will cover using Docker Machine, Compose and Swarm. In the first tutorial we setup containers on 2 different hosts and linked them together to run a simple webpage. In this tutorial we will be setting up a [service explanation].

Machine allows us to create Docker hosts and control them without interacting with the host machines directly. This way you don't have to SSH to machines running the Docker daemon to run containers.

Compose simplifies the process of arranging and linking containers together. Compose lets us specify the links and runtime configurations of containers in a single config file, rather than having several lengthy commands to execute in the right sequence.

Swarm is used to group multiple Docker hosts together so that containers can run and scale across machines.

Machine, Compose, and Swarm can be used together to simply and powerfully orchestrate a service. This is what we'll doing in this tutorial.

## Prerequisites

It's expected that you have gone through the [first Docker tutorial]() or are already familiar with its content. No more prior knowledge is required past the first tutorial. This tutorial uses a Chameleon baremetal machine running CentOS 7.

## Steps Outline

\# | Description | Time (mins)
---|-------------|------------
TBD

## Setup

Launch a Chameleon baremetal instance running CentOS 7 then execute the following installation commands. If you're using a different OS here are the installation instructions for [Docker](https://docs.docker.com/installation/), [Machine](https://docs.docker.com/machine/#installation), and [Compose](https://docs.docker.com/compose/install/).

```bash
sudo yum update -y
sudo yum install -y docker
sudo -i
curl -L https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine
curl -L https://github.com/docker/compose/releases/download/1.3.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
exit
```

## Machine

**We're creating local VM's with Machine rather than remote physical or virtual machines.** We're doing this because Machine doesn't currently support passing in reservation ids during host creation and therefore does not work with Chameleon. If Chameleon was compatible we could create and control remote Docker hosts from a Chameleon instance or from your personal computer. Support for Chameleon will likely happen in the future. See this [issue](https://github.com/docker/machine/issues/1461) on their GitHub.

## Compose

### Containers in Composition

Level | Name | Apps Running
------|------|------------
1 | http_server | Nginx
2 | page_generator | uWSGI, Django
2 | image_processor | uWSGI, Django, OpenCV

The http_server container will act as the front for both the page_generator and image_processor containers. I think this way I can also set up the image_processor first and test it without the webpage.
