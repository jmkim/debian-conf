#!/bin/bash


#
# Flush all current rules
#
iptables -F


#
# Access for SSH
#
iptables -A INPUT -p tcp --dport ssh -j ACCEPT


#
# Default policies
#
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT


#
# Access for localhost
#
iptables -A INPUT -i lo -j ACCEPT


#
# Established and related connections
#
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


#
# Packet forwarding (for DHCP server)
#
iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT


#
# Port forwarding
#


#
# Access for specific port (Out->In)
#

# HTTP
#iptables -A INPUT -p tcp --dport http -j ACCEPT
#iptables -A INPUT -p tcp --dport 9999 -j ACCEPT

# FTP
#iptables -A INPUT -p tcp --dport ftp-data -j ACCEPT
#iptables -A INPUT -p tcp --sport 1024: --dport 1024: -j ACCEPT

# NTP
iptables -A INPUT -p udp --dport ntp -j ACCEPT


#
# Save settings
#
iptables-save > /etc/iptables/rules.v4
iptables-restore < /etc/iptables/rules.v4
iptables-apply


#
# List rules
#
iptables -L -v
