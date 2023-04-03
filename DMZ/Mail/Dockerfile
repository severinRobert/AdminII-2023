FROM ubuntu:focal

RUN apt update && apt upgrade -y
RUN apt install postfix postfix-mysql dovecot-core dovecot-pop3d dovecot-imapd vim net-tools mailutils mutt telnet -y


RUN mkdir -p /etc/postfix/ssl && \
    openssl genrsa -out /etc/postfix/ssl/server.key 2048 && \
    openssl req -new -key /etc/postfix/ssl/server.key -out /etc/postfix/ssl/server.csr -subj "/CN=mail.woodytoys.be" && \
    openssl x509 -req -days 365 -in /etc/postfix/ssl/server.csr -signkey /etc/postfix/ssl/server.key -out /etc/postfix/ssl/server.crt && \
    cat /etc/ssl/certs/ca-certificates.crt >> /etc/postfix/ssl/ca-certificates.crt

COPY --chown=root:root mysql_virtual_domains_maps.cf /etc/postfix/mysql_virtual_domains_maps.cf
COPY --chown=root:root mysql_virtual_mailbox_maps.cf /etc/postfix/mysql_virtual_mailbox_maps.cf
COPY --chown=root:root mysql_virtual_alias_maps.cf /etc/postfix/mysql_virtual_alias_maps.cf

RUN chmod 600 /etc/postfix/mysql_virtual_domains_maps.cf
RUN chmod 600 /etc/postfix/mysql_virtual_mailbox_maps.cf
RUN chmod 600 /etc/postfix/mysql_virtual_alias_maps.cf
