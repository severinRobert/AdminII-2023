$ORIGIN l1-3.ephec-ti.be.
$TTL	3600
@	IN	SOA	ns.l1-3.ephec-ti.be.   root.l1-3.ephec-ti.be. (

    2022061457 ; serial
    21600      ; refresh after 6 hours
    3600       ; retry after 1 hour
	1814000     ; expire after 3 week
	86400 )    ; minimum TTL of 1 day

;Nom de serveur faisant autoriter sur le domaine l1-3.ephec-ti.be.
@      IN      NS      ns.l1-3.ephec-ti.be.


;Le nom de mon serveur assigner à son IP
ns			IN	A	164.92.131.165;

;Server Web
b2b	IN	A	164.92.131.165;
www	IN	A	164.92.131.165;

;Server Mail
mail	IN	A	164.92.131.165;
@	IN	MX	10	mail;


