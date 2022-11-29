#!/bin/ash

podman build -t sshd:latest .

mkdir -p /var/sshd-jump

cp -R authorized_keys /var/sshd-jump/authorized_keys
cp sshd_config /var/sshd-jump/sshd_config

cp sshd-jump.rc /etc/init.d/sshd-jump
rc-update add sshd-jump
service sshd-jump start
