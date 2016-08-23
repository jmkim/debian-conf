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
#iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT
#iptables -A FORWARD -i lxc-bridge-nat -o eth0 -j ACCEPT
#iptables -A FORWARD -i eth0 -o lxc-bridge-nat -j ACCEPT


#
# Port forwarding
#
#iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 9001 -j DNAT --to 192.168.56.13:80


#
# Access for specific port (Out->In)
#

# HTTP
#iptables -A INPUT -p tcp --dport http -j ACCEPT

# FTP (passive)
#iptables -A INPUT -p tcp --dport ftp-data -j ACCEPT
#iptables -A INPUT -p tcp --sport 1024: --dport 1024: -j ACCEPT

# NTP
#iptables -A INPUT -p udp --dport ntp -j ACCEPT

# bootpc
#iptables -A INPUT -p udp --dport bootpc -j ACCEPT

# bootps
#iptables -A INPUT -p udp --dport bootps -j ACCEPT


#
# Access for ICMP (ping)
#
#SERVER_IP[0]="210.125.112.52"
#SERVER_IP[1]="192.168.56.1"

#for server_ip in ${SERVER_IP[*]}
#do
#    # Incoming
#    iptables -A INPUT -p icmp --icmp-type echo-request -s 0/0 -d $server_ip -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#    iptables -A OUTPUT -p icmp --icmp-type echo-reply -s $server_ip -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT
#
#    # Outgoing
#    iptables -A OUTPUT -p icmp --icmp-type echo-request -s $server_ip -d 0/0 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#    iptables -A INPUT -p icmp --icmp-type echo-reply -s 0/0 -d $server_ip -m state --state ESTABLISHED,RELATED -j ACCEPT
#done


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
