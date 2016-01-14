FROM debian:stable

MAINTAINER minanon

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y isc-dhcp-server samba krb5-user --no-install-recommends \
    && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# add files
COPY "add_files/dhcp_add.conf" "add_files/start.sh" "add_files/updatedns.sh" "/"
COPY "add_files/scripts" "/scripts"
RUN chmod 755 -R /start.sh /updatedns.sh /scripts

ADD https://raw.githubusercontent.com/minanon/functions.shell/master/functions.bash /functions.bash

# extenal setting
VOLUME [ "/etc/dhcp" ]
EXPOSE 67/udp

ENTRYPOINT [ "/start.sh" ]
