## DNS
### Arborescence des fichiers

```
trusted-zone/
 |--DNS/
     |--db.10.0.0
     |--db.woodytoys.be
     |--db.woodytoys.lab
     |--named.conf
docker-compose.yml
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

### Modification du service
**ATTENTION** après chaque modification il faut relancer le container avec la commande `docker-compose up soa-interne`.
#### Ajouter un sous-domaine
Pour ajouter un sous-domaine à woodytoys.[be/lab] il suffit d'ajouter le Ressource Record au fichier de zone `db.woodytoys.[be/lab]`. C'est de bonne pratique de créer un record inverse dans le fichier de zone correspondant au réseaux du RR ajouter.

#### Ajouter une nouvelle zone
On peut aussi ajouter une nouvelle zone, par exemple on ajoute un site web sur l'adresse `www.woodytoys.internal`.
* Créer un fichier de zone `db.woodytoys.internal`.
```dns
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
```zone
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

#### Supprimer un sous-domaine
Supprimez simplement le Resource Record.

### Mises a jour
Pour mettre à jour le service : `apt upgrade bind9`

### Logs
Pour voir les logs : `docker logs soa-interne`

### Troubleshooting
Voici les outils utiles pour régler les erreurs du dns :
* `named-checkconf [nom de fichier]` : Permet de verifier la syntaxe du fichier de zone indiqué.
* `named-checkconf -z` : Permet de verifier la syntaxe des fichiers de zone importé dans le `named.conf`.
* `service named status` : Permet de voir si le service tourne au niveau du conteneur Docker.
* `dig [nome de domaine]` : Permet de vérifier si le serveur dns est accéssible et si il renvoi les bonnes adresses IP. On peut aussi utiliser `dig @[IP] [nom de domaine]` pour cibler le soa directement si le nom de domaine parent n'a pas encore été configurer. (La si la commande n'existe pas, elle peut être installer via le packet dnsutils)
* `docker ps -a` : Permet de voir les états de tous les conteneurs avec le service en train de tourner, les ports exposés et les ports ouverts à l'extérieur. Vérifier bien que l'état du conteneur `soa-interne` soit "UP" et que le port 53 soit exposé en tcp et udp.
* `docker exec -ti soa-interne ls /etc/bind` : Pour vérifier que les fichiers de configurations sont présents dans le conteneur.


