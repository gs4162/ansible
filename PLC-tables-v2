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

# Ask user for the Tailscale IP address (if it's required)
read -p "Please enter the Tailscale IP address: " tailscale_ip
echo "Debug: Tailscale IP = $tailscale_ip"

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
if sudo netfilter-persistent save; then
    echo "Rules saved successfully."
else
    echo "Error saving rules."
    exit 1
fi

# Add new iptables rules
if sudo iptables -t nat -A PREROUTING -p tcp -d $tailscale_ip --dport 44818 -j DNAT --to-destination $plc_ip:44818; then
    echo "TCP DNAT rule added successfully."
else
    echo "Error adding TCP DNAT rule."
    exit 1
fi

if sudo iptables -t nat -A PREROUTING -p udp -d $tailscale_ip --dport 44818 -j DNAT --to-destination $plc_ip:44818; then
    echo "UDP DNAT rule added successfully."
else
    echo "Error adding UDP DNAT rule."
    exit 1
fi

if sudo iptables -A FORWARD -p tcp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT; then
    echo "TCP FORWARD rule added successfully."
else
    echo "Error adding TCP FORWARD rule."
    exit 1
fi

if sudo iptables -A FORWARD -p udp -d $plc_ip --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT; then
    echo "UDP FORWARD rule added successfully."
else
    echo "Error adding UDP FORWARD rule."
    exit 1
fi

# Save iptables rules
if sudo netfilter-persistent save; then
    echo "Final rules saved successfully."
else
    echo "Error saving final rules."
    exit 1
fi
