$ORIGIN woodytoys.be.
$TTL	3600
@	IN	SOA	ns.woodytoys.be.   root.woodytoys.be. (

    2022061457 ; serial
    21600      ; refresh after 6 hours
    3600       ; retry after 1 hour
	1814000     ; expire after 3 week
	86400 )    ; minimum TTL of 1 day

;Nom de serveur faisant autoriter sur le domaine woodytoys.be.
@      IN      NS      ns.woodytoys.be.


;Le nom de mon serveur assigner à son IP
ns			IN	A	1.2.3.4;

;Server Web
b2b	IN	A	1.2.3.4;
www	IN	A	1.2.3.4;

;Server Mail
mail	IN	A	1.2.3.4;
@	IN	MX	10	mail;

