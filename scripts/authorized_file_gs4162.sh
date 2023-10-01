#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Install jq if not found
if ! command_exists jq; then
    echo "jq not found, installing..."
    sudo apt update && sudo apt install -y jq

    # Check again after attempting to install
    if ! command_exists jq; then
        echo "Failed to install jq. Exiting."
        exit 1
    fi
fi

# Navigate to the .ssh directory
cd ~/.ssh/

# Rename the current authorized_keys file if it exists
[ -e authorized_keys ] && mv authorized_keys authorized_keys.old

# Fetch the public keys from the GitHub user gs4162
curl -s https://api.github.com/users/gs4162/keys | jq -r '.[].key' > authorized_keys

# Set the correct permissions for the authorized_keys file and .ssh directory
chmod 600 authorized_keys
chmod 700 ~/.ssh/

# Self-delete the script
rm -- "$0"
