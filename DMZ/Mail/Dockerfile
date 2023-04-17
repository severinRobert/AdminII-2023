FROM ubuntu:focal

RUN apt update && apt upgrade -y
RUN apt install postfix dovecot-core dovecot-pop3d dovecot-imapd vim net-tools mailutils mutt telnet -y

RUN useradd contact -p contact
RUN useradd atelier -p atelier
RUN useradd direction -p direction
RUN useradd secretariat -p secretariat
RUN useradd compta -p compta
RUN useradd commerciaux -p commerciaux
