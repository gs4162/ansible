#!/bin/bash

# Function to check if a command exists
command_exists() {
    # Check for 'docker compose' specifically
    if [ "$1" == "docker compose" ]; then
        docker compose version &> /dev/null && return 0 || return 1
    else
        type "$1" &> /dev/null
    fi
}

# Update and upgrade system
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y

# Navigate to the desired directory
cd "$(pwd)" # Or replace with the specific directory you want to work in

# Check if 'docker compose' (v2) is available, otherwise use 'docker-compose' (v1)
if command_exists "docker compose"; then
    COMPOSE_COMMAND="docker compose"
elif command_exists "docker-compose"; then
    COMPOSE_COMMAND="docker-compose"
else
    echo "Neither 'docker compose' nor 'docker-compose' command is available."
    exit 1
fi

# Execute Docker Compose commands
$COMPOSE_COMMAND pull
$COMPOSE_COMMAND up -d

# Clean up Docker images and volumes
docker image prune -af
docker volume prune -f
