#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Create a new sudoers file for the ubuntu user
echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu

# Set appropriate permissions for the file
chmod 440 /etc/sudoers.d/ubuntu

# Validate all sudoers files
if visudo -c; then
  echo "Sudoers file valid"
else
  echo "Sudoers file invalid, removing..."
  rm /etc/sudoers.d/ubuntu
  exit
fi

# Remove the script itself
rm -- "$0"
