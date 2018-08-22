#!/bin/ash

# Configure networking
apk add bridge
cp -f network-interfaces /etc/network/interfaces
service networking restart

# Configure Kernel for IP forwarding
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/01-router.conf
sysctl -p /etc/sysctl.conf

# Install iptables and create rules
apk add iptables
service iptables stop
DEST="/etc/iptables/rules-save"
cp -f iptables $DEST
chmod 600 $DEST
rc-update add iptables
service iptables start

# Install and configure dnsmasq
apk add dnsmasq
cat dnsmasq dnsmasq.static-hosts > /etc/dnsmasq.conf
rc-update add dnsmasq
service dnsmasq restart

# Create and configure sshd jump service
ln -s /etc/init.d/sshd /etc/init.d/sshd.jump
echo 'SSHD_CONFDIR="/etc/ssh/jump"' > /etc/conf.d/sshd.jump
mkdir /etc/ssh/jump
cp -f sshd_config.jump /etc/ssh/jump/sshd_config
rc-update add sshd.jump
service sshd.jump restart

# Create jump user
adduser -D -H -h /dev/null -s /bin/true jump
DEST="/etc/ssh/jump/jump.authorized_keys"
cp -f authorized_keys.jump $DEST
chown root:jump $DEST
chmod 640 $DEST

# Configure sshd for maintenance access
cp -f sshd_config.maint /etc/ssh/sshd_config
service sshd restart

# Create maintenance user
adduser -u 2000 -D maintenance
DEST="/etc/ssh/authorized_keys"
cp -f authorized_keys.maint $DEST
chown root:maintenance $DEST
chmod 640 $DEST
