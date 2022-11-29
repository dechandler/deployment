#!/bin/ash


# Configure Kernel for IP forwarding
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/01-router.conf
sysctl -p /etc/sysctl.conf


# Configure network interfaces
apk add bridge
cp -f network-interfaces /etc/network/interfaces
service networking restart


# IPTABLES: Install and Create Rules
apk add iptables
service iptables stop
cp -f iptables /etc/iptables/rules-save
chmod 600 /etc/iptables/rules-save
rc-update add iptables
service iptables start


# iptables Manager for Rules Defined by DNS Names
cp -f dns-rules.conf /etc/iptables/dns-rules.conf
chmod 600 /etc/iptables/dns-rules.conf
cp -f dns-rules.sh /etc/periodic/15min/
chmod 700 /etc/periodic/15min/dns-rules.sh


# Setup dnsmasq
apk add dnsmasq
cp -f dnsmasq.conf /etc/dnsmasq.conf
rc-update add dnsmasq
service dnsmasq restart
