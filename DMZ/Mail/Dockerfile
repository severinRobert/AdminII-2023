FROM dovecot/dovecot

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y postfix opendkim opendmarc
RUN apt-get install -y systemctl
RUN apt-get install -y mailutils
RUN apt-get install -y iputils-ping
RUN apt-get install -y telnet

COPY main.cf /etc/postfix/
COPY dovecot.conf /etc/dovecot/
COPY master.cf /etc/postfix/

COPY dkim/l1-3.ephec-ti.be.dkim.private /etc/opendkim/keys/
COPY dkim/l1-3.ephec-ti.be.dkim.txt /etc/opendkim/keys/

COPY dkim/opendkim.conf /etc/
COPY dkim/signtable /etc/opendkim/
COPY dkim/keytable /etc/opendkim/
COPY dkim/internalhosts /etc/opendkim/

COPY dmarc/opendmarc.conf /etc/
COPY dmarc/ignore.hosts /etc/opendmarc/

RUN useradd -rm -p $(openssl passwd -1 contact) contact
RUN useradd -rm -p $(openssl passwd -1 b2b) b2b
RUN useradd -rm -p $(openssl passwd -1 atelier) atelier

#VOLUME /home



