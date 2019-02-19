#!/bin/ash

# Configure networking
apk add bridge
cp -f network-interfaces /etc/network/interfaces
service networking restart

# Configure Kernel for IP forwarding
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/01-router.conf
sysctl -p /etc/sysctl.conf

# IPTABLES: Install and Create Rules
apk add iptables
service iptables stop
DEST="/etc/iptables/rules-save"
cp -f iptables $DEST
chmod 600 $DEST
rc-update add iptables
service iptables start

# DNSMASQ: Install and Configure
apk add dnsmasq
cat dnsmasq dnsmasq.static-hosts > /etc/dnsmasq.conf
rc-update add dnsmasq
service dnsmasq restart

# SSHD: Maintenance Service
cp -f sshd_config.maint /etc/ssh/sshd_config
echo 'rc_need="net"' >> /etc/conf.d/sshd
service sshd restart

# SSHD: Jump Service
mkdir /etc/ssh/jump
cp -f sshd_config.jump /etc/ssh/jump/sshd_config
ln -s /etc/init.d/sshd /etc/init.d/sshd.jump
echo 'cfgfile="/etc/ssh/jump/sshd_config"' > /etc/conf.d/sshd.jump
rc-update add sshd.jump
service sshd.jump restart

# Create maintenance user
adduser -u 2000 -D maintenance
DEST="/etc/ssh/authorized_keys"
cp -f authorized_keys.maint $DEST
chown root:maintenance $DEST
chmod 640 $DEST

# Create jump group and user
addgroup jump
adduser -D -H -h /dev/null -s /bin/true -G jump jump-david
passwd -u jump-david
DEST="/etc/ssh/jump/jump-david.authorized_keys"
cp -f authorized_keys.jump-david $DEST
chown root:jump $DEST
chmod 640 $DEST

# Automatically update and selectively reboot via cron
echo -e '#!/bin/ash
apk update && apk upgrade
' > /etc/periodic/daily/update
echo -e '#!/bin/ash
find /boot -name "initramfs-vanilla" -mtime -7 | grep i || reboot
' > /etc/periodic/weekly/reboot
chmod 755 /etc/periodic/*/*

apk update
apk upgrade
reboot