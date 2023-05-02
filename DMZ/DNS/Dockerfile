FROM ubuntu/bind9

RUN apt update && apt upgrade -y

WORKDIR /etc/bind

COPY ./db.l1-3.ephec-ti.be .

RUN dnssec-keygen -a RSASHA256 -b 2048 -f KSK l1-3.ephec-ti.be
RUN dnssec-keygen -a RSASHA256 -b 1280 l1-3.ephec-ti.be

RUN for key in `ls Kl1-3*.key`; do echo "\$INCLUDE /etc/bind/$key">> db.l1-3.ephec-ti.be; done

RUN dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) -N INCREMENT -o l1-3.ephec-ti.be -t db.l1-3.ephec-ti.be

