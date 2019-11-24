# Tysons Code & Coffee - Docker Fundamentals Content

# Introduction
## Installation

1. Install docker desktop or engine from the following locations 
   *  https://www.docker.com/products/docker-desktop or
   *  https://docs.docker.com/install/

    Use the following command to verify the Docker engine is running on your machine.

    ```
    docker version
    ```

    Docker version displays information regarding the docker client and docker server. Docker engine listens on REST API endpoints and performs all actions remotely. Results are sent back to the client to display. `docker version` display version information and verifies that the client and the API server are both working correctly.

    Note: On Windows 10, switch to Linux containers and Share your "C" drive using settings from the Docker tray icon.

## Basic Commands

```bash
# Download centos image from docker hub. Docker hub is the default container image registry
# 'centos' is the image name '7' is the tag we need
docker pull centos:7

# Check images available on your machine
docker image ls

# Download alpine Linux image.
docker pull alpine

# Check local images and notice docker pulled 'latest' tag for alpine
docker image ls

# Run our first container. Note container runs and exits
docker run hell-world

# Check local images, notice docker CLI automatically pulled the 'hello-world:latest' image for us
docker image ls

# Lets run the alpine container. Notice that the container runs and quits immediately without any display
docker run alpine

# Run alpine container again but attache your terminal to the container
docker run -ti alpine

# NOTE: Run following commands inside the 'alpine' container

# Check IP address. Note it's different from your machine's IP address
ip addr

# Create a file
echo 'Hello container' > test.txt
cat test.txt

# Exit from the container
exit

# Run the alpine container again and note 
docker run -ti alpine

# NOTE: Run following commands inside the 'alpine' container

# Note that the file you created previously is gone
cat test.txt

# Exit out of the container
exit

# Create folder on your machine
mkdir share

# Run alpine container again but mount a volume from your host machine using '-v' option
# On Windows you have to enter the absolute path. You may enter current path in Mac or Linux
docker run -ti -v C:\Users\faheem\codes\tysons\share:/share alpine sh

# Inside the container
echo 'Hello container' > /share/test.txt
exit

# Get contents from the current folder and notice that the file is preserved
ls ./share

# Publish ports of the docker container on the host using '-p' option
docker run -d -p 4000:80 nginx

# Either check the response in your browser 'localhost:4000' or do curl
curl http://localhost:4000

# The '-d' switch runs the container in detached mode (background)
# Use the following command to see all running containers
docker container ls

# Stop the running container using the following command
docker stop <copy and paste the container id from the previous command>

# Check non-running containers
docker container ls -a

# Clean all non-running containers and other cruft using the following command
docker system prune

# System prune doesn't delete container images
docker image ls

# Run Nginx container again and do curl
docker run -d -p 4000:80 nginx
curl localhost:4000

# Run following command to get console output from the container
docker container ls
docker logs <nginx container id>

# Stop the Nginx container and clean-up
docker container stop <nginx container id>
docker container rm <nginx container id>
```
Docker image vendors use tags to release multiple version of the same software. `latest` is a special tag which always points to the current release. It may not be suitable for production scenarios. For production look for `stable`, `lts`, or specific version tags.

## Building container images

### HTML Website using NGINX

```bash
# Clone this repository
git clone https://github.com/memonfaheem/tysons-code-coffee-docker-fundamentals.git

# Checkout ngix folder
cd nginx
ls 
# code_coffee.jpeg: Image used on the page
# default.conf:  NGINX configuration
# Dockerfile: Default dockerfile used to build docker build
# index.html: Our HTML code we want to deploy

cat Dockerfile
# 'FROM' command specifies our base image. We are going to build on top of the nginx:alpine image
# We are using 'COPY' commands to copy files from our folder context to the image 

# Build our docker image
# '-t' specifies the name and tag of the image. 'latest' tag is assumed if none is specified
# '.' at the end is the folder context sent to the docker
docker build -t hello-tysons .

# Check local images, note our image is created successfully
docker image ls

# Let's run our new image. The '--rm' option will remove the container automatically when stopped.
docker run -d --rm -p 4000:80 hello-tysons

# Open http://localhost:4000 in your browser

# Stop the container
docker container ls
docker container stop <container id>

# Open index.html and change 'Hello World!' to 'Hello Tysons Code & Coffee!"
# Rebuild and run the container
docker build -t hello-tysons .

# Run, test and stop the container
docker run -d --rm -p 4000:80 hello-tysons
curl http://localhost:4000
docker container stop (docker container ls -aq)
```

### Angular App
```bash
# Change directory to angular-app
cd .\angular-app\

# The application has angular files, Dockerfile, multi-stage.Dockerfile, and nginx.conf

# You would need angular CLI to build the app. Instead, if you want to build inside another docker container, skip these steps and move to the multi-stage build
npm install
ng build -prod 
docker built -t angular-app .
docker image ls

# Test the new container
docker run -d --rm -p 3000:80 angular-app
docker container ls
curl localhost:3000

# Stop the angular container
docker container stop $(docker container ls -aq)

# Multi-stage Build Images: Instead of building the application locally and 
# then copying the ./dist files to the image. We use another container to build
# the app and copy the files over to the eventual container mid-flight.
docker build -t angular-app2 -f .\multi-stage.Dockerfile .
docker image ls

# Test the new image
docker run -d --rm -p 3000:80 angular-app2 
docker container ls
curl http://localhost:3000

# Stop the angular conatiner
docker container stop $(docker conatiner ls -aq)
```
### FunFact (DotNet Core App)
```bash
# Build .NET App Container
cd ../funfact
docker build -t funfact .

# Test conatiner
docker run -d --rm -p 5000:5000 funfact
curl http://localhost:5000
curl http://localhost:5000/home/fact

# Stop the container
docker container stop $(docker container ls -aq)
```