FROM ubuntu:focal

RUN apt update && apt upgrade -y
RUN apt install postfix dovecot-core dovecot-pop3d dovecot-imapd vim net-tools mailutils mutt telnet -y

RUN adduser contact
RUN adduser atelier
RUN adduser direction
RUN adduser secretariat
RUN adduser compta
RUN adduser commerciaux
