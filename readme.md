# Simple Sudoers Add Script

To quickly add a user to the `sudoers` file, run the following commands:

```bash
curl -o add-sudoers.sh https://raw.githubusercontent.com/gs4162/ansible/master/add-sudoers.sh
chmod +x add-sudoers.sh
sudo ./add-sudoers.sh
```

###### PLC IP Tables Configuration Script
```
curl -o PLC-ip-tables.sh https://raw.githubusercontent.com/gs4162/ansible/master/PLC-ip-tables.sh
chmod +x PLC-ip-tables.sh
sudo ./PLC-ip-tables.sh
```
```
curl -o PLC-ip-tables-v2.sh https://raw.githubusercontent.com/gs4162/ansible/master/PLC-ip-tables-v2.sh
chmod +x PLC-ip-tables-v2.sh
sudo ./PLC-ip-tables-v2.sh
```
```
curl -o PLC-ip-tables-v3.sh https://raw.githubusercontent.com/gs4162/ansible/master/PLC-ip-tables-v3.sh
chmod +x PLC-ip-tables-v3.sh
sudo ./PLC-ip-tables-v3.sh
```
```
curl -o PLC-ip-tables-v3.sh https://raw.githubusercontent.com/gs4162/ansible/master/scripts/plc-ip-routes/PLC-ip-tables-v4.sh
chmod +x PLC-ip-tables-v4.sh
sudo ./PLC-ip-tables-v4.sh
```


###### default network "Disable the above"
```
sudo iptables -F && sudo iptables -t nat -F && sudo systemctl disable netfilter-persistent && sudo rm /etc/iptables/rules.v4 && sudo rm /etc/iptables/rules.v6 && sudo reboot
```

