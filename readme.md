# What is a container

- A way to package application with all the necessary dependencies and configuration
- Portable artifact, easily shared and moved around between dev team
- Makes dev and deployment more efficient

# Where do containers live? 

- Container repository
- Private repository
- Public repository (hub.docker.com)

## Application development

### Before containers
- Install on each operating system one by one
- Installation process is different
- Many steps

### After containers
- Own isolared environment
- Packaged all needed config
- One command to install the app
- Run same app with 2 different versions

## Application deployment

### Before containers
- Produce artifacts
- Configuration on server is needed 
- Dependency version conflicts
- Misunderstanding

### After containers
- Dev and Operations work together to package application
- No environmental config needed on server - except docker runtime on server to run containers


## Containers
- Layers of stacked images (Mostly linux base image) alpine:3.10
- Applicaiton image on top
- Public repo (without login)

```bash
# pulls image and runs it (you can use it to run multiple versions on machine)

docker run postgres:9.6
``` 

```sh
# see all running containers and image
docker ps
``` 

## Dockers image vs Docker container

### Docker image
- the actual package
- artifacts can be moved around

### Docker Container
- Running mode
- actually start the application
- container environment is created

## Docker vs Virtual Machine
- Docker on OS level
  - Applications run on Kernel layer
  - Docker vitrualize the applications layer (size is much smaller)
    - Faster bootup speed
  - Virtual machine virtualizes complete operating system (GB large)
  - docker toolbox
- Different level of abstractions


# Basic Docker Commands

Difference between image and container
- Container is the running environment for image
- Port binded
- virtual file system

_All artifacts in Dockerhub are images_

```sh
docker pull [image] # pull image from hub
docker run [image] # will create a new container
docker ps # list running containers
docker run -d [image] # detached mode (to reuse same terminal)
docker stop [ID_OF_CONTAINER] # stop container
docker start [ID_OF_CONTAINER] # start containers (retains all attribute)
docker ps -a # list all containers (running and stopped)
docker images # list all images

## Debugging
docker logs [CONTAINER_ID|NAME] # get logs 
docker run -d -p6000:6379 --name [NEW_IMAGE_NAME] [IMAGE] # renaming image
docker logs [CONTAINER_ID] | tail # get latest
docker logs [CONTAINER_ID] -f # stream logs
docker exec -it [CONTAINER_ID|NAME] /bin/bash # interactive terminal to enter docker's own terminal /bin/sh
exit # exit terminal
```

# Container port vs Host Port
- Multiple containers running on host machine
- Create binding on laptop port and docker container port

## How to create port binding
```sh
docker run -p6000:3739 [image] -d # localhost:container port 
```

```sh
-d
# Docker will start your container the same as before but this time will “detach” from the container and return you to the terminal prompt. To use terminal again
```


# Simplified workflow with Docker
Develop -> commit to Git -> Jenkins CI -> Artifact -> Build and create docker image -> Pushed to private docker repo

Dev server pulls both images (app and used image)

# Developing with containers
- Pull images from docker hub
- Docker network - isolated network where containers are running
- App will connect to this network

```sh
docker network ls # shows all network available
docker network create [NETWORK-NAME]` # creates new network
```

### Run image on the network
```sh
docker run -d \
    -p [host]:[container]
    -e MONG_INIT_DB_ROOT_USERNAME=admin // environment variable
    -e MONG_INIT_DB_ROOT_password=password
    --name mongo-db 
    --net [NETWORK-NAME]
    [IMAGE]
```

```
sh docker run -d \
    -p [host]:[container]
    -e MONG_INIT_DB_ROOT_USERNAME=admin
    -e MONG_INIT_DB_ROOT_password=password
    --name mongo-db 
    --net [NETWORK-NAME]
    [IMAGE]
```

## Connect node js to DB
- Use mongo client to connect to db (use the host port)
`docker logs

# Using Docker Compose
- mapping docker commands
- structured way to contain very normal common docker commands

```
version: '3'
services:
  [CONTAINER_NAME]:
    image: [IMAGE NAME]
    ports:
      - 27017:27017
    environment:
      - ENV_VARIABLES HERE
```

PS: DOCKER COMPOSE TAKES CARE OF CREATION OF NETWORK

```sh
docker-compose -f [FILE_NAME] up # start containers and creates network
```

_PS: There is no data persistence on containers (keep in mind) so once you restart container, everything is lost
BUT VOLUMES TO THE RESCUE (USED FOR DATA PERSISTENCE)_

```sh
docker-compose -f [FILE_NAME] down # stops all services and network is gone
```


# Dockerfile
- Blueprint for building docker images
- To deploy, app needs to packages to it's own docker container
- build docker image and deploy to env


See sample dockerfile


## Build image using Dockerfile
```sh
docker build -t my-app:1.0 . # -t is tag 2nd parameter is allocation (usually current directory)
```

Jenkins build a docker image based on Dockerfile

Whenever docker file is adjusted, we must rebuild the image

```sh
docker rm [CONTAINER_ID] # delete container
docker rmi [IMAGE_ID] # delete image
env # to see env inside interactive terminal when using exec command
```

## Private Docker Registry (amazon ecr)
- Go to AWS and find service names ECR (Elastic container registry)
- Create a repository per image (only on AWS)

### Push image to repository (docker login)
You need AWS CLI and credentials
```sh
docker login # login
```

## Name in docker registry
registryDomain/imageName:tag - in Docker Hub it's shorthand

```sh
docker pull mongo:4.2 # is shorthand for
docker pull docker.io/library/mongo:4.2
```

in AWS ECR:
`docker pull [registryName]/my-app:1.0

`docker tag my-app:1.0 [registryName]/my-app:1.0` - took a copy and made an identical copy of image with different repository


## Applying changes
### Build
`docker build -t my-app:1.1 .` . is path to docker file
`docker images` check images
`docker tag my-app:1.1 [registryName]/my-app:1.1`
`docker push [registryName]/my-app:1.1` - push to repo

NOTE: One repository with different image versions


## Deploy Containerized app (using docker compose)
- Need all containers 


# Docker volumes
- used for data persistence
- plug physical files system to container (mounted)
## 3 types of volumes
- `docker run -v [HOST_DIRECTORY]:[CONTAINER_DIRECTORY]` - host volumes
- `docker run -v [CONTAINER_DIRECTORY]` - anonymous volumes
- `docker run -v name:[CONTAINER_DIRECTORY]` - named volumes (prefered use)

(How ot add in docker-compose) check docker-componse.yml file

## See where docker volumes are located
- Windows
  C:ProgramData/docker/volumes
- Linux
  /var/lib/docker/volumes
- Mac
  /var/lib/docker/volumes

Docker creates linux virtual machine on mac
`screen ~/Library/Containers/com.docker.docker/Data/com.docker/driver.amd64-linux/tty`
Ctrl a + k = kill screen session