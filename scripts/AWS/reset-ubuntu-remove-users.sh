#!/bin/bash

echo "Updating package lists..."
sudo apt update

echo "Upgrading packages..."
sudo apt upgrade -y

echo "Reinstalling Ubuntu Desktop..."
sudo apt install --reinstall ubuntu-desktop

echo "Removing unnecessary packages..."
sudo apt autoremove

echo "Resetting GNOME settings..."
dconf reset -f /org/gnome/

echo "Removing user 'ubuntu' configuration files..."
rm -rf /home/ubuntu/.config
rm -rf /home/ubuntu/.local
rm -rf /home/ubuntu/.gnome
rm -rf /home/ubuntu/.cache

echo "Removing user 'mhm' configuration files..."
rm -rf /home/mhm/.config
rm -rf /home/mhm/.local
rm -rf /home/mhm/.gnome
rm -rf /home/mhm/.cache


echo "Rebooting the system..."
sudo reboot
