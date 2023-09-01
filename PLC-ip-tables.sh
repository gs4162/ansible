#!/bin/bash

# Ask user for the PLC IP address
read -p "Please enter the PLC IP address: " plc_ip

# Extract the Tailscale IP address from the system
tailscale_ip=$(ip addr show tailscale0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Check if Tailscale IP was successfully extracted
if [[ -z "$tailscale_ip" ]]; then
    echo "Error: Could not find Tailscale IP."
    exit 1
fi

# Configure iptables rules for TCP and UDP port forwarding
sudo iptables -t nat -A PREROUTING -p tcp -d $tailscale_ip --dport 44818 -j DNAT --to-destination $plc_ip:44818
sudo iptables -t nat -A PREROUTING -p udp -d $tailscale_ip --dport 44818 -j DNAT --to-destination $plc_ip:44818

# Configure iptables rules for FORWARD chain
sudo iptables -A FORWARD -p tcp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -p udp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

echo "iptables configured successfully."
