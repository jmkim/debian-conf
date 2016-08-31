#!/bin/bash

#
# Set the IP address of this machine
#
#SERVER_IP[0]="192.168.83.1"
#SERVER_IP[1]="121.174.208.27"
#SERVER_IP[2]="192.168.56.1"


#
# Set the iptables rules
#
iptables_set_rules()
{
    echo -n "Setting new iptables rules... "
    #
    # Packet forwarding (for DHCP server)
    #
#    iptables -t filter -A FORWARD -i eth0 -o eth0 -j ACCEPT
#    iptables -t filter -A FORWARD -i lxc-bridge-nat -o eth0 -j ACCEPT
#    iptables -t filter -A FORWARD -i eth0 -o lxc-bridge-nat -j ACCEPT

    #
    # IP masquerading (for DHCP server)
    #
#    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    #
    # Port forwarding
    #
#    for server_ip in ${SERVER_IP[*]}
#    do
#        iptables -t nat -A PREROUTING -i eth0 -p tcp -d $server_ip --dport 9001 -j DNAT --to 192.168.56.13:80
#        iptables -t nat -A PREROUTING -i eth0 -p tcp -d $server_ip --dport http -j DNAT --to 192.168.56.14:80
#        iptables -t nat -A PREROUTING -i eth0 -p tcp -d $server_ip --dport https -j DNAT --to 192.168.56.14:443
#    done

    #
    # Access for specific port (Out->In)
    #
#    # HTTP
#    iptables -t filter -A INPUT -p tcp --dport http -j ACCEPT
#
#    # HTTPS
#    iptables -t filter -A INPUT -p tcp --dport https -j ACCEPT
#
#    # FTP (passive)
#    iptables -t filter -A INPUT -p tcp --dport ftp-data -j ACCEPT
#    iptables -t filter -A INPUT -p tcp --sport 1024: --dport 1024: -j ACCEPT
#
#    # NTP
#    iptables -t filter -A INPUT -p udp --dport ntp -j ACCEPT
#
#    # bootpc
#    iptables -t filter -A INPUT -p udp --dport bootpc -j ACCEPT
#
#    # bootps
#    iptables -t filter -A INPUT -p udp --dport bootps -j ACCEPT

    #
    # Access for ICMP (ping)
    #
#    for server_ip in ${SERVER_IP[*]}
#    do
#        # Incoming
#        iptables -t filter -A INPUT -p icmp --icmp-type echo-request -s 0/0 -d $server_ip -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#        iptables -t filter -A OUTPUT -p icmp --icmp-type echo-reply -s $server_ip -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT
#
#        # Outgoing
#        iptables -t filter -A OUTPUT -p icmp --icmp-type echo-request -s $server_ip -d 0/0 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#        iptables -t filter -A INPUT -p icmp --icmp-type echo-reply -s 0/0 -d $server_ip -m state --state ESTABLISHED,RELATED -j ACCEPT
#    done
    echo "done."
}


#
# Flush all existing iptables rules
#
iptables_flush_all()
{
    echo -n "Flushing all existing iptables rules... "
    iptables -t filter -F

    # Access for keeping the remote connection
    iptables -t filter -A INPUT -p tcp --dport ssh -j ACCEPT    

    iptables -t nat -F
    iptables -t mangle -F
    iptables -t raw -F
    iptables -t security -F

    # Delete all of user-defined chains
    iptables -X
    echo "done."
}


#
# Fallback policies
#
iptables_set_default_policy()
{
    iptables -t filter -P INPUT DROP

    # Access for localhost
    iptables -t filter -A INPUT -i lo -j ACCEPT

    # Established and related connections
    iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    iptables -t filter -P FORWARD DROP
    iptables -t filter -P OUTPUT ACCEPT
}


#
# Apply the iptables rules
#
iptables_apply()
{
    echo -n "Installing new iptables rules... "
    iptables-save > /etc/iptables/rules.v4
    iptables-restore < /etc/iptables/rules.v4
    echo "done."
    iptables-apply
}


#
# List the iptables rules
#
iptables_show()
{
    if [[ -z "$1" ]]; then

        table_names[0]="filter"
        table_names[1]="nat"

        for tname in ${table_names[*]}
        do
            echo "List of the rules in table \"$tname\":"
            iptables -t $tname -L -v
            echo ""
        done

    else

        echo "[$1]"
        iptables -t "$1" -L -v

    fi
}

iptables_show_all()
{
    table_names[0]="filter"
    table_names[1]="nat"
    table_names[2]="mangle"
    table_names[3]="raw"
    table_names[4]="security"

    for tname in ${table_names[*]}
    do
        echo "List of the rules in table \"$tname\":"
        iptables -t $tname -L -v
        echo ""
    done
}


#
# Main
#
case "$1" in
    install)
        iptables_flush_all
        iptables_set_default_policy
        iptables_set_rules
        iptables_apply
        ;;

    remove)
        iptables_flush_all
        iptables_set_default_policy
        ;;

    show)
        iptables_show "$2"
        ;;

    show-all)
        iptables_show_all
        ;;

    *)
        echo "Usage: $0 {install|remove|show|show-all}"
        echo "       $0 show [table name]"
        exit 1
esac
