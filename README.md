#docker-bind
DNS server using BIND

##Introduction
This is to run BIND DNS server

##Maintainer
minanon

##
- use 53(UDP and TCP) port number
- save setting file to /etc/named

##RUN

    docker run -d --name bind -p 53:53/udp -p 53:53 -v /opt/docker/data/bind:/etc/named -d minanon/bind
