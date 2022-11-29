#!/bin/sh

addgroup jump

for JUMP_USER in "$(ls /etc/ssh/authorized_keys)"; do

    adduser -D -H -h /dev/null -s /bin/true -G jump ${JUMP_USER}
    PASS="$(head -c1000 /dev/urandom | sha512sum | head -c128)"
    echo "${JUMP_USER}:${PASS}" | chpasswd
    passwd -u -d ${JUMP_USER}

done


exec /usr/sbin/sshd
