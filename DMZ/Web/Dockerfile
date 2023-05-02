from php:7.2-apache

RUN apt update && apt upgrade -y


RUN apt install -y openssl certbot python3-certbot-apache

# Certificats pour le site www
RUN openssl genrsa -out /etc/ssl/certs/www.key 2048
RUN openssl req -new -sha256 -key /etc/ssl/certs/www.key -out /etc/ssl/certs/www.csr -subj "/C=BE/ST=Brabant-wallon/L=Louvain-La-Neuve/O=Ephec/OU=IT/CN=www.l1-3.ephec-ti.be"
RUN openssl x509 -req -days 365 -in /etc/ssl/certs/www.csr -signkey /etc/ssl/certs/www.key -out /etc/ssl/certs/www.crt

# Certificats pour le site b2b
RUN openssl genrsa -out /etc/ssl/certs/b2b.key 2048
RUN openssl req -new -sha256 -key /etc/ssl/certs/b2b.key -out /etc/ssl/certs/b2b.csr -subj "/C=BE/ST=Brabant-wallon/L=Louvain-La-Neuve/O=Ephec/OU=IT/CN=b2b.l1-3.ephec-ti.be"
RUN openssl x509 -req -days 365 -in /etc/ssl/certs/b2b.csr -signkey /etc/ssl/certs/b2b.key -out /etc/ssl/certs/b2b.crt

# Certificats pour le site intranet
RUN openssl genrsa -out /etc/ssl/certs/intranet.key 2048
RUN openssl req -new -sha256 -key /etc/ssl/certs/intranet.key -out /etc/ssl/certs/intranet.csr -subj "/C=BE/ST=Brabant-wallon/L=Louvain-La-Neuve/O=Ephec/OU=IT/CN=intranet.woodytoys.lab"
RUN openssl x509 -req -days 365 -in /etc/ssl/certs/intranet.csr -signkey /etc/ssl/certs/intranet.key -out /etc/ssl/certs/intranet.crt


