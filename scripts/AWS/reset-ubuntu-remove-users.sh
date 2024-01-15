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

# Obtain the last 4 characters of the MAC address
last_four_chars=$(get_last_four_mac_chars)

# Prompt the user for automatic hostname setting or default
read -p "Press 'Y' for automatic hostname based on MAC address, or press Enter for default 'mhm-edge-$last_four_chars': " user_choice
if [ "$user_choice" = "Y" ] || [ "$user_choice" = "y" ]; then
    auto_hostname="FW2B-$last_four_chars"
    set_hostname "$auto_hostname"
else
    default_hostname="mhm-edge-$last_four_chars"
    set_hostname "$default_hostname"
fi

echo "Removing most installed packages and configurations..."
sudo apt-get remove --purge -y $(dpkg --get-selections | grep -v deinstall | awk '{print $1}')
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo rm -rf /home/* /root/*

echo "Disabling SSH service..."
sudo systemctl disable ssh
sudo systemctl stop ssh

echo "Downloading the AWS SSM Agent..."
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb

echo "Installing the AWS SSM Agent..."
sudo dpkg -i amazon-ssm-agent.deb

# Prompting user for AWS SSM details with default region as us-east-1
read -p "Enter your AWS SSM Activation Code: " ssm_code
read -p "Enter your AWS SSM Activation ID: " ssm_id
read -p "Enter your AWS Region [us-east-1]: " ssm_region
ssm_region=${ssm_region:-us-east-1}

echo "Registering the instance with AWS Systems Manager..."
sudo amazon-ssm-agent -register -code "$ssm_code" -id "$ssm_id" -region "$ssm_region"

echo "Starting the SSM Agent Service..."
sudo systemctl start amazon-ssm-agent

echo "Checking the SSM Agent Service Status..."
sudo systemctl status amazon-ssm-agent

# Sleep for 5 seconds to allow the user to read the status
sleep 5

echo "Rebooting the system..."
sudo reboot
