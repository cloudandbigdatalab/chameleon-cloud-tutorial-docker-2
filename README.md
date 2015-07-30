# Chameleon Cloud Tutorial - Docker Machine, Compose, and Swarm

**Because of incompatibilities, part of this tutorial uses the Rackspace cloud instead of Chameleon resources. See the [Machine](#machine) section for details.**

This tutorial will cover using Docker Machine, Compose and Swarm. Ultimately these tools are intended to be used together but because they're not yet mature that synthesis is limited. We'll discuss the limitations in more detail throughout the tutorial. We'll instead focus on using each tool individually and demonstrate them together in ways that currently work.

### Compose
Compose simplifies the process of arranging and linking containers together. Compose lets us specify the links and runtime configurations of containers in a single config file, rather than having several lengthy commands to execute in the right sequence. In the first tutorial we setup containers on 2 different hosts and linked them together to run a simple webpage. In this tutorial we will set up a similar page that lets you post messages and lists those previously posted. It uses 3 containers and we'll arrange them with Compose.

### Machine
Machine allows us to create Docker hosts and control them without interacting with the host machines directly. This way you don't have to SSH to machines running the Docker daemon to run containers. Chameleon won't work for this part of the tutorial because of problems with Chameleon's lease system. Support for Chameleon will likely happen in the future. See this [issue](https://github.com/docker/machine/issues/1461) on their GitHub. You could also use virtual machines running on a Chameleon instance but we ran into issues installing VirtualBox on the default Chameleon CentOS image. So for now we're going to demo Machine with Rackspace to give you an idea of its potential. **We will be controlling everything from a Chameleon machine however.**

### Swarm
Swarm is used to group multiple Docker hosts together so that containers or groups of containers can scale across machines. We'll also be demoing this on Rackspace because we use Machine to setup our Swarm.

## Prerequisites

It's expected that you have gone through [Docker Tutorial 1](http://cloudandbigdatalab.github.io/docs/Chameleon%20Cloud%20Tutorial%20-%20Docker%20Fundamentals.pdf) or are already familiar with its content. No more prior knowledge is required past the first tutorial.

## Steps Outline

\# | Description | Time (mins)
---|-------------|------------
? | ? | ?

## Setup

We'll be using the default Chameleon CentOS image for this tutorial.

```sh
sudo yum update -y

sudo yum install -y docker curl

sudo service docker start
```

Then follow these instructions to install [Machine](https://docs.docker.com/machine/#installation) and [Compose](https://docs.docker.com/compose/install/). **If you're getting "Permission Denied" using curl, run `sudo -i` to become root, run the commands, then `exit`.**

If you're going to try to use Machine with Rackspace, VM's, or another provider follow they're docs to get setup.  It's fairly easy to complete the demo with VM's on your own physical machine.

## Docker Compose

With Compose you outline your container configuration and arrangement with a YAML file name docker-compose.yml. Our [docker-compose.yml](https://github.com/cloudandbigdatalab/chameleon-cloud-tutorial-docker-2/blob/master/docker-compose.yml) is on our GitHub. This lays out the 3 container composition. In our docker-compose.yml we specify to pull out images from Docker Hub. All the resources, including the Dockerfile, to build these images is available on our [GitHub](https://github.com/cloudandbigdatalab/chameleon-cloud-tutorial-docker-2). If you wanted to build the images yourself or make modifications, download the repo then change

```yml
image: cloudandbigdatalab/server:tutorial-2
```

to

```yml
build: ./server
```

to build and use a local image. We're assuming the Dockerfile for server is in the server folder within the current directory. You would do the same for the page container. Note for the db container we're using the unmodified Postgres image off Docker Hub so their isn't a folder for it. Here's a quick explanation of what's going on with our composition.

Container Name | Apps | Description
----------|------|------------
server | Nginx | handles http requests
page | uWSGI and Django | uWSGI connects Nginx to Django, Django generates the html
db | Postgres | database for page, Django connects to Postgres

### Run the Composition

```shell
docker-compose -p tutorial up -d
```

`-p tutorial` specifies our project name. Otherwise it uses the name of the current directory.
