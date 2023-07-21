#!/bin/bash

# Define the network range
NETWORK="192.168.0.0/16"

# Scan the network for used addresses
nmap -sn $NETWORK -oG - | awk '/Up$/{print $2}' > used_ips.txt

# Try to find a free IP
for i in {1..254}; do
  for j in {1..254}; do
    # Construct the potential IP
    IP="192.168.$i.$j"

    # Check if the IP is used
    if ! grep -q $IP used_ips.txt; then
      echo "Found free IP: $IP"
      FREE_IP=$IP
      break 2
    fi
  done
done

# Set the static IP
if [[ -n $FREE_IP ]]; then
  echo "Setting static IP to $FREE_IP"
  sudo ip addr add $FREE_IP/24 dev eth0
  echo "Static IP set to $FREE_IP"
else
  echo "No free IP found in the network."
fi

# Clean up
rm used_ips.txt
