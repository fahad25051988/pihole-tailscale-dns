#!/bin/bash

docker run -d \
  --name pihole \
  -p 53:53/tcp -p 53:53/udp \
  -p 80:80 -p 443:443 \
  -e TZ="Asia/Kolkata" \
  -e WEBPASSWORD="yourpassword" \
  -v $(pwd)/../pihole/etc-pihole:/etc/pihole \
  -v $(pwd)/../pihole/etc-dnsmasq.d:/etc/dnsmasq.d \
  --dns=127.0.0.1 --dns=1.1.1.1 \
  --restart=unless-stopped \
  --cap-add=NET_ADMIN \
  pihole/pihole:latest
