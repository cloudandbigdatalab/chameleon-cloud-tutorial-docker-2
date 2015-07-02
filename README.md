# Chameleon Cloud Tutorial - Docker 2

:warning::warning::warning: **Tutorial Under Development** :warning::warning::warning:

This tutorial will cover using Docker Machine and Compose.

Machine:
I think I want to have them spin up multiple Chameleon servers then show them how to use Docker on them via Machine rather than SSH'ing to each Chameleon host. So basically just simplifying your workflow if all your using is Docker.

Compose:
I want to take what I did in the first tutorial and wrap that up with Compose. That seems like a good idea. In the first part I had all the separate Docker files and then you strung it together with commands. So now I can show how to streamline what we already did.

I'm not sure how or if I want to relate these two more together. I think I could get them setup with Machine then have the Compose script interface with that. I think that's possible but not sure.

**End of Notes**

## Machine

In the first tutorial we spun up Chameleon servers and accessed them directly via SSH. In this tutorial we're going to control them via Docker Machine. This is particularly useful if you're only working with Docker containers.

**Need to figure out OpenStack API information for Chameleon then proceed.**

### Installing Docker Machine on Your Local System

Docker Machine is available for Linux, OS X, and Windows. See the Docker installation [instructions] (https://docs.docker.com/machine/install-machine/) for your OS. I'm using a Mac in the example and executed the following. **Be aware, I could not follow the instructions on that page verbatim.** Even with `sudo` the curl command returned permission denied.

```sh
curl -L https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_darwin-amd64 > ~/Downloads/docker-machine
sudo mv ~/Downloads/docker-machine /usr/local/bin/
chmod +x /usr/local/bin/docker-machine
```
