yum -y install suricata
#Updated config /etc/suricata/suricata.yaml to include
HOME_NET: "[10.10.28.61]"
#Check the below reflects ur interface
af-packet:
  - interface: eth0
#Using default rules
default-rule-path: /var/lib/suricata/rules
rule-files:
 - suricata.rules

#Disable packet offloading
#Check if enabled
ethtool -k eth0 | grep -iE "generic|large"
#If so - disable
sudo ethtool -K eth0 gro off lro off

#Download latest rules
suricata-update

#Check config syntax
suricata -c /etc/suricata/suricata.yaml -T -v

#Check interface in /etc/sysconfig/suricata matches ur interface
#Start suricata
systemctl start suricata

#Tested using hping3 commands from node01
