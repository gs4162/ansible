#!/bin/bash

# Warning: This script will make significant changes to your system.

# Function to obtain the last 4 characters of the MAC address
get_last_four_mac_chars() {
    local mac_address=$(ip link show enp1s0 | grep link/ether | awk '{print $2}')
    local last_four_chars=${mac_address//:/}
    echo ${last_four_chars: -4}
}

# Function to set hostname
set_hostname() {
    local new_hostname=$1
    echo "Setting new hostname to $new_hostname"
    echo $new_hostname | sudo tee /etc/hostname
    sudo hostnamectl set-hostname $new_hostname
    echo "127.0.1.1 $new_hostname" | sudo tee -a /etc/hosts
}

# Check for root privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Obtain the last 4 characters of the MAC address
last_four_chars=$(get_last_four_mac_chars)

# Prompt the user for automatic hostname setting or default
read -p "Press 'Y' for automatic hostname based on MAC address, or press Enter for default 'mhm-edge-xxxx': " user_choice
if [ "$user_choice" = "Y" ] || [ "$user_choice" = "y" ]; then
    auto_hostname="mhm-edge-$last_four_chars"
    set_hostname "$auto_hostname"
else
    default_hostname="mhm-edge-xxxx"
    set_hostname "$default_hostname"
fi

echo "Removing most installed packages and configurations..."
sudo apt-get remove --purge -y $(dpkg --get-selections | grep -v deinstall | awk '{print $1}')
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo "Disabling SSH service..."
sudo systemctl disable ssh
sudo systemctl stop ssh

echo "Downloading the AWS SSM Agent..."
sudo snap stop amazon-ssm-agent
sudo snap remove amazon-ssm-agent
sudo mkdir -p /tmp/ssm
sudo wget -O /tmp/ssm/ssm-setup-cli https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/debian_amd64/ssm-setup-cli

# Prompting user for AWS SSM details with default region as us-east-1
read -p "Enter your AWS SSM Activation Code: " ssm_code
read -p "Enter your AWS SSM Activation ID: " ssm_id

sudo chmod +x /tmp/ssm/ssm-setup-cli
sudo /tmp/ssm/ssm-setup-cli -register -activation-code "$ssm_code" -activation-id "$ssm_id" -region "us-east-1" -override

echo "Registering the instance with AWS Systems Manager..."

# Check if AWS SSM Agent is running
sudo systemctl start amazon-ssm-agent
sleep 10 # Give it some time to start
if systemctl is-active --quiet amazon-ssm-agent; then
    echo "AWS SSM Agent is active and running."
    echo "Rebooting the system..."
    sudo reboot
else
    echo "Error: AWS SSM Agent did not start properly. Please check the logs and try again."
    exit 1
fi
