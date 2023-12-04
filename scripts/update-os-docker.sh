#!/bin/bash

# Update and upgrade packages
apt update
apt full-upgrade -y
apt autoremove -y

# Navigate to the current working directory
cd "$(pwd)"

# Perform docker operations
docker-compose pull
docker-compose up -d
docker image prune -af
docker volume prune -f
