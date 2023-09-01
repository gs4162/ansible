#!/bin/bash

# Debug: Show current directory and files
echo "Debug: Current directory and files"
ls -al

# Preconfigure and install iptables-persistent if not already installed
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent

# Clear existing iptables rules for port 44818
sudo iptables -t nat -D PREROUTING -p tcp --dport 44818 -j DNAT 2>/dev/null
sudo iptables -t nat -D PREROUTING -p udp --dport 44818 -j DNAT 2>/dev/null
sudo iptables -D FORWARD -p tcp --dport 44818 -j ACCEPT 2>/dev/null
sudo iptables -D FORWARD -p udp --dport 44818 -j ACCEPT 2>/dev/null

# Reset iptables to default (Uncomment the following lines if you need to reset iptables)
# sudo iptables -F
# sudo iptables -t nat -F
# sudo iptables -t mangle -F
# sudo iptables -X
# sudo iptables -t nat -X
# sudo iptables -t mangle -X
# sudo iptables -P INPUT ACCEPT
# sudo iptables -P FORWARD ACCEPT
# sudo iptables -P OUTPUT ACCEPT
# sudo netfilter-persistent save

# Ask user for the PLC IP address
read -p "Please enter the PLC IP address: " plc_ip

# Extract the network part of the PLC IP address for Tailscale
IFS='.' read -ra ADDR <<< "$plc_ip"
plc_network="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.0/24"

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

# Save iptables rules
sudo netfilter-persistent save

# Setup Tailscale sub-routing
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# Activate Tailscale with the advertised routes
sudo tailscale up --advertise-routes=$plc_network

# Remove this script
rm -- "$0"
