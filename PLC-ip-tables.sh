#!/bin/bash

# Debug: Show current directory and files
echo "Debug: Current directory and files"
ls -al

# Install iptables-persistent if not installed
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent || exit 1

# Ask user for the PLC IP address
read -p "Please enter the PLC IP address: " plc_ip
echo "Debug: PLC IP = $plc_ip"

# Remove previous rules
sudo iptables -t nat -D PREROUTING -p tcp --dport 44818 -j DNAT --to-destination $plc_ip:44818 2>/dev/null
sudo iptables -t nat -D PREROUTING -p udp --dport 44818 -j DNAT --to-destination $plc_ip:44818 2>/dev/null
sudo iptables -D FORWARD -p tcp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 2>/dev/null
sudo iptables -D FORWARD -p udp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 2>/dev/null

# Reset iptables to default
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X
sudo iptables -t nat -X
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Save iptables rules
sudo netfilter-persistent save || exit 1

# Extract the Tailscale IP address
tailscale_ip=$(ip addr show tailscale0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "Debug: Tailscale IP = $tailscale_ip"

# Check if Tailscale IP was extracted
if [[ -z "$tailscale_ip" ]]; then
  echo "Error: Could not find Tailscale IP."
  exit 1
fi

# Add new iptables rules
sudo iptables -t nat -A PREROUTING -p tcp -d $tailscale_ip --dport 44818 -j DNAT --to-destination $plc_ip:44818 || exit 1
sudo iptables -t nat -A PREROUTING -p udp -d $tailscale_ip --dport 44818 -j DNAT --to-destination $plc_ip:44818 || exit 1
sudo iptables -A FORWARD -p tcp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT || exit 1
sudo iptables -A FORWARD -p udp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT || exit 1

# Save iptables rules
sudo netfilter-persistent save || exit 1
