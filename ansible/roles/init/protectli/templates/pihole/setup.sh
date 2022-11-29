#!/bin/ash

adduser -D -H -h /dev/null -s /bin/false pihole
echo 'pihole:10000:65536' > /etc/subuid
echo 'pihole:10000:65536' > /etc/subgid







sudo podman run -d \
    --name=pihole \
    -e TZ=Europe/Berlin \
    -e WEBPASSWORD=password \
    -e SERVERIP=127.0.0.1 \
    -v pihole:/etc/pihole \
    -v dnsmasq:/etc/dnsmasq.d \
    -p 80:80 \
    -p 53:53/tcp \
    -p 53:53/udp \
    --restart=unless-stopped \
    pihole/pihole
