# Virtualization and Cloud Computing

## Introduction

This project is a basic implementation of a load balancer for distributing incoming requests from clients to multiple backend servers in a load-balanced manner.

## Build Docker Images

Build the load balancer image:
```bash
docker build -t ldblrimg .
```

Build the Flask application image for backend servers:

```bash
docker build -t flaskappimg appfolder/.
```

## Start Server Containers

```bash
./container.sh [run|stop|remove] [n]

```
Replace [run|stop|remove] with the desired action.<br>
Replace [n] with the number of server containers to manage.


## Start Load Balancer
```bash
docker run -it --cap-add=NET_ADMIN --network=subnett --ip=168.0.0.2 ldblrimg bash
```


### Inside the load balancer container, run the script to configure load balancing:

```bash
./script.sh [n] [r|p]
```
Replace [n] with the number of server containers.<br>
Use r for round-robin forwarding or p for probabilistic forwarding of requests.
