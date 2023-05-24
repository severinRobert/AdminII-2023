from php:7.2-apache

RUN apt update && apt upgrade -y


RUN apt install -y openssl

# Certificats pour le site intranet
RUN openssl genrsa -out /etc/ssl/certs/intranet.key 2048
RUN openssl req -new -sha256 -key /etc/ssl/certs/intranet.key -out /etc/ssl/certs/intranet.csr -subj "/C=BE/ST=Brabant-wallon/L=Louvain-La-Neuve/O=Ephec/OU=IT/CN=intranet.woodytoys.lab"
RUN openssl x509 -req -days 365 -in /etc/ssl/certs/intranet.csr -signkey /etc/ssl/certs/intranet.key -out /etc/ssl/certs/intranet.crt


