#!/bin/bash

# Warning: This script will make significant changes to your system.

echo "Removing most installed packages and configurations..."
sudo apt-get remove --purge -y $(dpkg --get-selections | grep -v deinstall | awk '{print $1}')
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo rm -rf /home/* /root/*

echo "Resetting hostname..."
sudo hostnamectl set-hostname ubuntuSCRIPTED

echo "Disabling SSH service..."
sudo systemctl disable ssh
sudo systemctl stop ssh

echo "Downloading the AWS SSM Agent..."
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb

echo "Installing the AWS SSM Agent..."
sudo dpkg -i amazon-ssm-agent.deb

# Prompting user for AWS SSM details
read -p "Enter your AWS SSM Activation Code: " ssm_code
read -p "Enter your AWS SSM Activation ID: " ssm_id
read -p "Enter your AWS Region: " ssm_region

echo "Registering the instance with AWS Systems Manager..."
sudo amazon-ssm-agent -register -code "$ssm_code" -id "$ssm_id" -region "$ssm_region"

echo "Starting the SSM Agent Service..."
sudo systemctl start amazon-ssm-agent

echo "Checking the SSM Agent Service Status..."
sudo systemctl status amazon-ssm-agent

echo "Rebooting the system..."
sudo reboot
