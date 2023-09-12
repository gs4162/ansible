#!/bin/bash

# Get the path to this script
SCRIPT_PATH="$0"

# Ask the user for the PLC IP and Tailscale IP, with default values provided
read -p "Please enter the PLC IP address [default: 192.168.10.102]: " plc_ip
plc_ip=${plc_ip:-192.168.10.102} # default to 192.168.10.102 if no input

read -p "Please enter the Tailscale IP address [default: 100.82.83.133]: " tailscale_ip
tailscale_ip=${tailscale_ip:-100.82.83.133} # default to 100.82.83.133 if no input

# Apply the iptables rules using the provided IPs
sudo iptables -t nat -A PREROUTING -p tcp -d "$tailscale_ip" --dport 44818 -j DNAT --to-destination "$plc_ip":44818
sudo iptables -t nat -A PREROUTING -p udp -d "$tailscale_ip" --dport 44818 -j DNAT --to-destination "$plc_ip":44818
sudo iptables -A FORWARD -p tcp -d "$plc_ip" --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -p udp -d "$plc_ip" --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Delete the script itself
rm -f "$SCRIPT_PATH"
