FROM ubuntu:focal

RUN apt update && apt upgrade -y
RUN apt install postfix dovecot-core dovecot-pop3d dovecot-imapd vim net-tools mailutils mutt telnet -y

RUN useradd contact -p contact
RUN useradd atelier -p atelier
RUN useradd direction -p direction
RUN useradd secretariat -p secretariat
RUN useradd compta -p compta
RUN useradd commerciaux -p commerciaux

RUN openssl req -new -x509 -days 3650 -nodes -newkey rsa:4096 -out /etc/ssl/certs/mailcert.pem -keyout /etc/ssl/private/mailcert.key -subj "/C=BE/ST=Braban-wallon/L=Wavre/O=Ephec/OU=IT/CN=mail.l1-3.ephec-ti.be"

