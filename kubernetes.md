# What is Kubernetes?

## Definition

Open source container orchestration tool from Google. It helps you manage containerized applications that made up of thousands of containers and manage them in different deployment environments

## What problems it solves? 

Due to increase trend from Monolith to Microservices, it has increased usage of containers.
Demand of orchestration tool

Features:
1. High availability or no downtime
2. Scalability or high performance
3. Disaster recovery - backup and restore

## K8s Components

### Pod
- Smallest unit of K8s
- Abstraction over container
- Creates layer on top of container
- Usually meant to run one app per Pod

K8s have virtual network - internal public address

### Services
- Permanent IP address can be attached to each Pod
- Lifecycle of Pod and Service are **NOT** connected

### Ingress
- Forwarding to Service to have nice url
- Route traffic to cluster

### ConfigMap
- External configuration of your application
- Maps automatically

### Secret
- Used to store secret data
- base64 encoded format 
- can store credentials

## Concepts

### Data Storage

Before, if DB container is restarted, data is gone. Volumes is now to the rescue
- Local machine
- Remote 

Storage is external hard drive 

### Deployment
To create a 2nd replica, you need to create a blue print using **Deployment** component
- Abstraction of Pods
- Can't replicate Database using Deployment
- for stateLESS Apps

### StatefulSet
- for stateFUL Apps or Databases
- Meant for stateful applications (databases)
- deploying is not easy
- DB are often hosted outside K8's cluster to avoid inconsistencies and hard deployment


## K8s Basic Architecture

Kubelet interacts with both container and node
