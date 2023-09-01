# Simple Sudoers Add Script

To quickly add a user to the `sudoers` file, run the following commands:

```bash
curl -o add-sudoers.sh https://raw.githubusercontent.com/gs4162/ansible/master/add-sudoers.sh
chmod +x add-sudoers.sh
sudo ./add-sudoers.sh

# PLC IP Tables Configuration Script

To quickly set up IP tables for a PLC, you can use the PLC-ip-tables.sh script. Here's how to download, set permissions, and run the script:

```bash
curl -o PLC-ip-tables.sh https://raw.githubusercontent.com/your_repository/your_path/PLC-ip-tables.sh
chmod +x PLC-ip-tables.sh
sudo ./PLC-ip-tables.sh
