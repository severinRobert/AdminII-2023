#!/bin/sh
# This file need to be run as super user to work
DMZ_NET="172.16.0.0/24"
SOA_EXTERNE="172.16.0.2"
WEB="172.16.0.3"
MAIL="172.16.0.4"

DB_NET="10.2.0.0/24"
DB="10.2.0.2"

SECURED_NET="10.0.0.0/24"
SOA_INTERNE="10.0.0.2"
ERP="10.0.0.3"

USER_NET="10.1.0.0/24"
ATELIER="10.1.0.2"
COMPTA="10.1.0.3"
DIRECTION="10.1.0.4"
HANGAR="10.1.0.5"


# Connect Mail with the USER network
iptables -I FORWARD -p tcp --match multiport -s $USER_NET -d $MAIL --dports 25,110,143,465,587,993 -j ACCEPT
iptables -I FORWARD -p tcp --match multiport -s $MAIL --sports 25,110,143,465,587,993 -d $USER_NET -j ACCEPT

# Connect Web with the USER network
iptables -I FORWARD -p tcp --match multiport -s $USER_NET -d $WEB --dports 80,443 -j ACCEPT
iptables -I FORWARD -p tcp --match multiport -s $WEB --sports 80,443 -d $USER_NET -j ACCEPT

# Connect Web with the DB
iptables -I FORWARD -p tcp --match multiport -s $WEB -d $DB --dports 3306 -j ACCEPT
iptables -I FORWARD -p tcp --match multiport -s $DB --sports 3306 -d $WEB -j ACCEPT
iptables -I FORWARD -p tcp --match multiport -s $ERP -d $DB --dports 3306 -j ACCEPT
iptables -I FORWARD -p tcp --match multiport -s $DB --sports 3306 -d $ERP -j ACCEPT

# DNS
iptables -I FORWARD -p tcp --match multiport -s $USER_NET -d $SOA_INTERNE --dports 53 -j ACCEPT
iptables -I FORWARD -p udp --match multiport -s $USER_NET -d $SOA_INTERNE --dports 53 -j ACCEPT
iptables -I FORWARD -p tcp --match multiport -s $SOA_INTERNE --sports 53 -d $USER_NET -j ACCEPT
iptables -I FORWARD -p udp --match multiport -s $SOA_INTERNE --sports 53 -d $USER_NET -j ACCEPT

# ERP
iptables -I FORWARD -p tcp --match multiport -s $USER_NET -d $ERP --dports 80,443 -j ACCEPT
iptables -I FORWARD -p tcp --match multiport -s $ERP --sports 80,443 -d $USER_NET -j ACCEPT
