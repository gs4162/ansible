# Simple Sudoers Add Script

To quickly add a user to the `sudoers` file, run the following commands:

```bash
curl -o add-sudoers.sh https://raw.githubusercontent.com/gs4162/ansible/master/add-sudoers.sh
chmod +x add-sudoers.sh
sudo ./add-sudoers.sh


# PLC IP Tables Configuration Script
```bash
curl -o PLC-ip-tables.sh https://raw.githubusercontent.com/gs4162/ansible/master/PLC-ip-tables.sh
chmod +x PLC-ip-tables.sh
sudo ./PLC-ip-tables.sh

curl -o PLC-ip-tables-v2.sh https://raw.githubusercontent.com/gs4162/ansible/master/PLC-ip-tables-v2.sh
chmod +x PLC-ip-tables-v2.sh
sudo ./PLC-ip-tables-v2.sh

curl -o PLC-ip-tables-v3.sh https://raw.githubusercontent.com/gs4162/ansible/master/PLC-ip-tables-v3.sh
chmod +x PLC-ip-tables-v3.sh
sudo ./PLC-ip-tables-v3.sh


# default network

sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X && sudo iptables -t nat -X && sudo iptables -t mangle -X && sudo iptables -P INPUT ACCEPT && sudo iptables -P FORWARD ACCEPT && sudo iptables -P OUTPUT ACCEPT && sudo netfilter-persistent save

Reapply

echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p && sudo sysctl -w net.ipv4.ip_forward=1 && sudo iptables -t nat -A PREROUTING -p udp --dport 2222 -j DNAT --to-destination 192.168.10.102:2222 && sudo iptables -t nat -A PREROUTING -p tcp --dport 44818 -j DNAT --to-destination 192.168.10.102:44818 && sudo iptables -t nat -A PREROUTING -p udp --dport 44818 -j DNAT --to-destination 192.168.10.102:44818 && sudo iptables -A FORWARD -p udp --dport 2222 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT && sudo iptables -A FORWARD -p tcp --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT && sudo iptables -A FORWARD -p udp --dport 44818 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT && sudo apt update && sudo apt install -y iptables-persistent && sudo netfilter-persistent save

