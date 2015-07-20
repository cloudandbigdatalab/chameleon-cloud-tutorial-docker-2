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

## Setup

Launch a Chameleon baremetal instance running CentOS 7 then execute the following installation commands. If you're using a different OS here are the installation instructions for [Docker](https://docs.docker.com/installation/), [Machine](https://docs.docker.com/machine/#installation), and [Compose](https://docs.docker.com/compose/install/).

```sh
sudo -i

yum update -y
yum install -y docker wget

curl -L https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

curl -L https://github.com/docker/compose/releases/download/1.3.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# VirtualBox

wget -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo

wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
rpm -Uvh rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

wget http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
rpm --import RPM-GPG-KEY.dag.txt

yum install -y yum-plugin-priorities

yum --enablerepo rpmforge install -y dkms

yum groupinstall -y "Development Tools" --setopt=group_package_types=mandatory,default,optional
yum install -y kernel-devel

yum install -y VirtualBox-5.0

# End of VirtualBox

exit
```

## Setup Swarm Cluster

**We're creating local VM's rather than remote physical or virtual machines.** We're doing this because Machine doesn't currently support passing in reservation ids during host creation and therefore does not work with Chameleon. If Chameleon was compatible we could create and control remote Docker hosts from a Chameleon instance or from your personal computer. Support for Chameleon will likely happen in the future. See this [issue](https://github.com/docker/machine/issues/1461) on their GitHub.

### Swarm Token

Run the following command to generate a Swarm token. Save it.

```sh
sudo docker run swarm create
# d36cbc29b44f96c85ed7b47eb794a65f
```

### Swarm Master

Create the Swarm master.

```sh
sudo docker-machine create \
    -d virtualbox \
    --swarm \
    --swarm-master \
    --swarm-discovery token://d36cbc29b44f96c85ed7b47eb794a65f \
    swarm-master
```

## Compose

### Containers in Composition

Level | Name | Apps Running
------|------|------------
1 | http_server | Nginx
2 | page_generator | uWSGI, Django
2 | image_processor | uWSGI, Django, OpenCV

The http_server container will act as the front for both the page_generator and image_processor containers. I think this way I can also set up the image_processor first and test it without the webpage.
