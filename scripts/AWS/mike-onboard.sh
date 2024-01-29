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

# Confirm before purging installed packages
read -p "Are you sure you want to remove most installed packages? (Y/N): " confirm_purge
if [ "$confirm_purge" = "Y" ] || [ "$confirm_purge" = "y" ]; then
    echo "Removing most installed packages and configurations..."
    sudo apt-get remove --purge -y $(dpkg --get-selections | grep -v deinstall | awk '{print $1}')
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
fi

echo "Disabling SSH service..."
sudo systemctl disable ssh
sudo systemctl stop ssh

echo "Downloading the AWS SSM Agent..."
sudo snap stop amazon-ssm-agent
sudo snap remove amazon-ssm-agent
sudo mkdir -p /tmp/ssm
sudo wget -O /tmp/ssm/ssm-setup-cli https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/debian_amd64/ssm-setup-cli

# AWS SSM details are now hardcoded
ssm_code="naSHe625rAnTISTnmx+R"
ssm_id="82a16fc5-988a-4b43-837d-770b9218062b"

sudo chmod +x /tmp/ssm/ssm-setup-cli
sudo /tmp/ssm/ssm-setup-cli -register -activation-code "$ssm_code" -activation-id "$ssm_id" -region "us-east-1" -override

echo "Registering the instance with AWS Systems Manager..."

# Waiting for 20 seconds
echo "Waiting for 20 seconds for the system to complete the setup..."
sleep 20

echo "Installation complete. You may want to verify the status of AWS SSM Agent manually."
