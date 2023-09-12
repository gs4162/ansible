#!/bin/bash

# Description:
# This script sets up iptables rules to handle port forwarding and then 
# makes the rules persistent. The user is prompted for the PLC IP address, 
# while the Tailscale IP is auto-detected. After applying the rules and saving them,
# the script deletes itself.

# Get the path to this script
SCRIPT_PATH="$0"

# Ask the user for the PLC IP with default value provided
read -p "Please enter the PLC IP address [default: 192.168.10.102]: " plc_ip
plc_ip=${plc_ip:-192.168.10.102} # default to 192.168.10.102 if no input

# Auto-detect the Tailscale IP address
tailscale_ip=$(ip -o -4 addr show tailscale0 | awk '{print $4}' | cut -d'/' -f1)

# Apply the iptables rules using the provided and detected IPs
sudo iptables -t nat -A PREROUTING -p tcp -d "$tailscale_ip" --dport 44818 -j DNAT --to-destination "$plc_ip":44818
sudo iptables -t nat -A PREROUTING -p udp -d "$tailscale_ip" --dport 44818 -j DNAT --to-destination "$plc_ip":44818
sudo iptables -A FORWARD -p tcp -d "$plc_ip" --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -p udp -d "$plc_ip" --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Ensure netfilter-persistent is installed, saved and enabled on startup
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
sudo netfilter-persistent save
sudo systemctl enable netfilter-persistent

# Delete the script itself
rm -f "$SCRIPT_PATH"
