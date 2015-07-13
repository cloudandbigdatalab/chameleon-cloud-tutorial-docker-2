# Chameleon Cloud Tutorial - Docker 2

:warning: **Tutorial Under Development**

This tutorial will cover using Docker Machine and Compose. In the first tutorial we setup containers on 2 different hosts and linked them together to run a simple webpage. In this tutorial we will be setting up a different webpage using the Docker tools Machine and Compose to simplify organizing our containers together.

Machine allows us to spin up cloud hosts for our containers without having to interact with the host machines directly. It's like using Docker on your local machine but you're actually commanding remote hosts.

Compose simplifies the process of arranging and linking containers together. In this tutorial we have 2 containers, one running Nginx and one running uWSGI (with Django and an OpenCV script). Compose lets us specify the connections and runtime configurations of both containers in a single file, rather than having several lengthy commands to execute in the right sequence.

## Machine

:warning: :warning: :warning:  
**Docker Machine does not currently support passing in reservation ids during host creation and therefore does not work with Chameleon. So for this tutorial we're going to use the Rackspace cloud. Support for Chameleon will likely happen in the future. See this [issue](https://github.com/docker/machine/issues/1461) on their GitHub.**

In the first tutorial we spun up Chameleon servers and accessed them directly via SSH. In this tutorial we're going to control them via Docker Machine. This is particularly useful if you're only working with Docker containers.

### Installing Docker Machine on Your Local System

Docker Machine is available for Linux, OS X, and Windows. See the Docker installation [instructions] (https://docs.docker.com/machine/install-machine/) for your OS. I'm using a Mac in the example and executed the following. **Be aware, I could not follow the instructions on that page verbatim.** Even with `sudo` the curl command returned permission denied.

```sh
curl -L https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_darwin-amd64 > ~/Downloads/docker-machine
sudo mv ~/Downloads/docker-machine /usr/local/bin/
chmod +x /usr/local/bin/docker-machine
```

## Compose

### Containers in Composition

Level | Name | Apps Running
------|------|------------
1 | http_server | Nginx
2 | page_generator | uWSGI, Django
2 | image_processor | uWSGI, Django, OpenCV

The http_server container will act as the front for both the page_generator and image_processor containers. I think this way I can also set up the image_processor first and test it without the webpage.
