# DNS
## Arborescence des fichiers

```
.
├── docker-compose.yml
└── trusted-zone
    └── DNS
        ├── db.10.0.0
        ├── db.woodytoys.be
        ├── db.woodytoys.lab
        └── named.conf
```
Dans l'arborescence de fichier il y a les fichiers de zone:
* db.10.0.0 : pour le reverse DNS, notamment utile pour le service mail.
* db.woodytoys.be : pour les services externes
* db.woodytoys.lab : pour les services internes de l'entreprise

Et le fichier de configuration `named.conf` pour la configuration du service. 

Le docker-compose crée le conteneur à partir de l'image `ubuntu/bind9`, expose le port 53 en tcp/udp et crée des volumes pour donner les fichiers de configuration et de zones. Enfin la commande qui lance le service dns est `named -g`.

```yml
soa-interne:
    image: ubuntu/bind9
    expose:
      - 53/udp
      - 53/tcp
    volumes:
      - ./trusted-zone/DNS/named.conf:/etc/bind/named.conf
      - ./trusted-zone/DNS/db.woodytoys.be:/etc/bind/db.woodytoys.be
      - ./trusted-zone/DNS/db.woodytoys.lab:/etc/bind/db.woodytoys.lab
      - ./trusted-zone/DNS/db.10.0.0:/etc/bind/db.10.0.0
    command: named -g
    container_name: soa-interne
    networks:
      dmz_net:
        ipv4_address: 10.0.0.4
```

## Modification du service
**ATTENTION** après chaque modification il faut relancer le container avec la commande `docker-compose up soa-interne`.
### Ajouter un sous-domaine
Pour ajouter un sous-domaine à woodytoys.[be/lab] il suffit d'ajouter le Ressource Record au fichier de zone `db.woodytoys.[be/lab]`. C'est de bonne pratique de créer un record inverse dans le fichier de zone correspondant au réseaux du RR ajouter.

### Ajouter une nouvelle zone
On peut aussi ajouter une nouvelle zone, par exemple on ajoute un site web sur l'adresse `www.woodytoys.internal`.
* Créer un fichier de zone `db.woodytoys.internal`.
```DNS Zone
$ORIGIN woodytoys.internal.
$TTL	3600
@	IN	SOA	ns.woodytoys.internal.   root.woodytoys.internal. (
    2022061457 ; serial
    21600      ; refresh after 6 hours
    3600       ; retry after 1 hour
	1814000     ; expire after 3 week
	86400 )    ; minimum TTL of 1 day

;Nom de serveur faisant autoriter sur le domaine woodytoys.internal.
@      IN      NS      ns.woodytoys.internal.

;Le nom de mon serveur assigner à son IP
ns			IN	A	10.0.0.4;

;Server Web
www	IN	A	172.0.0.2;
```
* [Optionnel(mais fortement conseillé si ça référence un serveur mail)] Comme l'IP du serveur web est dans un autre réseau il faut créer un nouveau fichier de reverse DNS. On va le nommer `db.172.0.0`.
```DNS Zone
$TTL 604800 ; 1 semaine
$ORIGIN 0.0.172.in-addr.arpa.
@ IN SOA ns.woodytoys.lab. root.woodytoys.lab. (
    2013020905 ;serial
    3600 ; refresh (1 hour)
    3000 ; retry (50 minutes)
    4619200 ; expire (7 weeks 4 days 11 hours 6 minutes 40 seconds)
    604800 ; minimum (1 week)
)

2 IN PTR www.woodytoys.intranet.
```
* Ajouter le fichier de zone et de zone reverse à la configuration du dns dans le `named.conf`.
```
zone "woodytoys.internal" {
    type master;
    file "/etc/bind/db.woodytoys.internal";
};

zone "0.0.172.in-addr.arpa." {
	type master;
	file "/etc/bind/db.172.0.0";
};
```
* Ajouter les fichiers créés au conteneur :
```yml
      - ./trusted-zone/DNS/db.woodytoys.intranet:/etc/bind/db.woodytoys.intranet
      - ./trusted-zone/DNS/db.172.0.0:/etc/bind/db.172.0.0
```

### Supprimer un sous-domaine
Supprimez simplement le Resource Record.

## Mises a jour
Pour mettre à jour le service : `apt upgrade bind9`

## Logs
Pour voir les logs : `docker logs soa-interne`

## Troubleshooting
Voici les outils utiles pour régler les erreurs du dns :
* `named-checkconf [nom de fichier]` : Permet de verifier la syntaxe du fichier de zone indiqué.
* `named-checkconf -z` : Permet de verifier la syntaxe des fichiers de zone importé dans le `named.conf`.
* `service named status` : Permet de voir si le service tourne au niveau du conteneur Docker.
* `dig [nome de domaine]` : Permet de vérifier si le serveur dns est accéssible et si il renvoi les bonnes adresses IP. On peut aussi utiliser `dig @[IP] [nom de domaine]` pour cibler le soa directement si le nom de domaine parent n'a pas encore été configurer. (La si la commande n'existe pas, elle peut être installer via le packet dnsutils)
* `docker ps -a` : Permet de voir les états de tous les conteneurs avec le service en train de tourner, les ports exposés et les ports ouverts à l'extérieur. Vérifier bien que l'état du conteneur `soa-interne` soit "UP" et que le port 53 soit exposé en tcp et udp.
* `docker exec soa-interne ls /etc/bind` : Pour vérifier que les fichiers de configurations sont présents dans le conteneur.





# Web

## Arborescence des fichiers
```
├── DMZ
│   │
│   └── Web
│       ├── Dockerfile
│       ├── b2b.php
│       ├── b2b.woodytoys.be.conf
│       ├── default
│       │   └── index.html
│       ├── default.conf
│       ├── intranet.php
│       ├── intranet.woodytoys.lab.conf
│       ├── www.html
│       └── www.woodytoys.be.conf
├── database
│   └── init.sql
└──docker-compose.yml
```
Dans le répertoire Web, se trouvent les fichiers relatifs aux différents sites web de l'entreprise à savoir : 

Les fichiers relatifs au site statique `www.woodytoys.be` :

- Le fichier `www.html` qui contient la structure HTML de la page statique. 
- Le fichier `www.woodytoys.be.conf` qui contient les configurations du virtualHosting. 

Les fichiers relatifs au site dynamique `b2b.woodytoys.be` :

- Le fichier `b2b.php` qui contient la stucture de la page dynamique et les appels à la base de donnée (SELECT). 
- Le fichier `b2b.woodytoys.be.conf` qui contient les configurations du virtualHosting.

Les fichiers relatifs à l'intranet `intranet.woodytoys.lab`  : 

- Le fichier `intranet.php` qui contient la stucture de la page dynamique et les appels à la base de donnée (SELECT & INSERT). 
- Le fichier `intranet.woodytoys.lab.conf` qui contient les configurations du virtualHosting.

Le fichier `default.conf` :

- Le fichier qui permet d'indiquer le site par default que l'on souhaite afficher si il ne connait pas le nom de domaine demandé (ceci est une sécurité

Le fichier `Dockerfile` : 
- Lance apache (permet de consommer moins de ressource car update l'image au lieu de la reconstruire à chaque fois)

-> Virtual Hosting : Permet l'hébergement de plusieurs noms de domaine sur un seul serveur.

Dans le fichier `Database` se trouve le script nécessaire à la création des tables et à leur remplissage 

## Modification du service
**ATTENTION** après chaque modification il faut relancer le container avec la commande `docker-compose up web`.
### Comment ajouter un nouveau site web (ex : `www.exemple.woodytoys.be`) ?

1)  Créer la structure de la page dans le language désiré (ici HTML) dans un fichier `exemple.html` : 
```html
<html>
   <head>
   </head>
   <body>
       <h1> Page exemple </h1>
   </body>
</html>
```
2) Créer un fichier `www.exemple.woodytoys.be.conf` afin de mettre en place le virtualHosting. Pour ce faire veillez à respecter la structure suivante : 
```aconf
<VirtualHost *:80>
	ServerAdmin he201811@students.ephec.be
	ServerName www.exemple.woodytoys.be
	DocumentRoot /var/www/www.exemple.woodytoys.be/

	ErrorLog ${APACHE_LOG_DIR}/error.log              
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Ceci permet la création du site web en HTTP ce qui représente un manque de sécurité pour remédier à ça, nous allons passer en HTTPS : 

```aconf
<VirtualHost *:80>
	ServerAdmin he201811@students.ephec.be
	ServerName www.exemple.woodytoys.be
	DocumentRoot /var/www/www.exemple.woodytoys.be/

	ErrorLog ${APACHE_LOG_DIR}/error.log              
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:443>
	ServerAdmin he201811@students.ephec.be
	ServerName www.exemple.woodytoys.be/
	DocumentRoot /var/www/www.exemple.woodytoys.be/

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	
	SSLEngine on
	SSLCertificateFile /etc/ssl/certs/www.crt
	SSLCertificateKeyFile /etc/ssl/certs/www.key
</VirtualHost>
```

3) Allez ajouter les RR dans le fichier de zone DNS ( voir documentation DNS)

### Comment supprimer un ancien site web ? 

1) Supprimer les fichiers relatifs au site choisi ( sa structure et son .conf) 
2) Supprimer le ressource recorde du fichier de zone DNS ( voir documentation DNS)

## Mises a jour

### Comment mettre à jour Apache2 ? 

```aconf
$ sudo apt-get update && sudo apt-get upgrade
$ sudo apt install apache2
```

## Logs

### Comment accéder aux log en cas d'erreur ? 

Il existe dans Apache deux fichiers de log dans `var/log/apache` : 

- `error.log` : informations de diagnostiques et et erreurs rencontrées lors d'une demande. 

- `access.log` : stockage des évènements sur le serveur (ex : lorsque quelqu'un visite un site ext.. )

### Commandes utiles de troubleshooting 

- `Docker ps` : Permet de vérifier si le container web est up. 
- `Docker inspect` : Permet de lister les informations liées au Docker 
- `apachectl configtest` : test la validité du fichier de configuration du serveur Apache.




# Mail
## Arborescence des fichiers
## Modification du service

## Mises a jour

## Logs
Pour voir les logs du conteneur : `docker logs mail`

Pour voir les logs de postfix : `docker exec mail cat /var/log/postfix.log`

Pour voir les logs de dovecot : `docker exec mail cat /var/log/dovecot.log`

## Troubleshooting
Voici les outils utiles pour régler les erreurs du mail :

**Général**
* `telnet mail.woodytoys.be 25` : Permet l'envoi d'un mail à postfix grâce aux commandes HELO, MAIL, RCPT. Example de connection telnet :
```
Connected to mail.woodytoys.be
220 mail.woodytoys.be ESMTP Postfix
HELO woodytoys.be
250 mail.woodytoys.be
MAIL FROM: contact@woodytoys.be
250 2.1.0 Ok
RCPT TO: atelier@woodytoys.be
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
Ceci est le sujet du mail      

Et voici le contenu du mail
Bien à vous,
L'équipe l1-3
.
250 2.0.0 Ok: queued as EBB391B61EB
QUIT
221 2.0.0 Bye
Connection closed by foreign host
```
* `mutt` : Permet l'envoi de mail et la consultation des mails. Il faut configurer un fichier `~/.mutt/muttrc` pour l'authentification.
```
set imap_user = USERNAME@woodytoys.be
set imap_pass = PASSWORD

set spoolfile = +INBOX                  # Dossier pour enregistrer les mails
set header_cache = ~/.cache/mutt        # Configure le cache
```
* `dig [nome de domaine]` : Permet de vérifier si la configuration du dns fonctionne (La si la commande n'existe pas, elle peut être installer via le packet dnsutils)
* `docker ps -a` : Permet de voir les états de tous les conteneurs avec le service en train de tourner, les ports exposés et les ports ouverts à l'extérieur. Vérifier bien que l'état du conteneur `mail` soit "UP" et que le port 25, 110 et 143 soit ouverts à l'extérieur en tcp.

**Postfix**
* `postconf` : Permet d'afficher la configuration actuelle de postfix.
* `postfix check` : Permet de vérifier la configuration de postfix.
* `service postfix status` : Permet de voir si le service tourne au niveau du conteneur Docker.
* `docker exec mail ls /etc/postfix` : Pour vérifier que les fichiers de configurations sont présents dans le conteneur.

**Dovecot**
* `doveconf` : Permet d'afficher la configuration actuelle de dovecot.
* `doveconf 1>/dev/null && echo $?` : Permet de vérifier la configuration de dovecot.
* `service dovecot status` : Permet de voir si le service tourne au niveau du conteneur Docker.
* `docker exec mail ls /etc/dovecot` : Pour vérifier que les fichiers de configurations sont présents dans le conteneur.

