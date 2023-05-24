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
@	IN 	TXT 	"v=spf1 ip4:164.92.131.165 -all";
mail._domainkey.l1-3.ephec-ti.be.       1800    IN      TXT     ( "v=DKIM1; h=sha256; k=rsa; "
	  "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7wwJwRWfV2wvhakQ08gqcBsC0HzPbgW3pomynJU9cQtcr4QuD2hl9qSK9mkprvBPyxYRSIhntQIUSdazFY+1BGZZ+5W0lPyOZHGdnj05j3LdaMQGt+OvTdhNgSereACqRd4r+84cpAiDW+SVJjOaVM8BA5+mTXa4s4iFaDi8U7aVslDSv8a9lBG+w/Nqxv6p8CUbfXwoQRJc7G"
	  "+2Lm4uSyF5t1CsrvSmJgWxsz+sDlUKKxvIvP5sKHdxDMf4c7tChNhdRvOFasw+3zC0FLw47wS+JTJuE/qdSdwYWpI5EFFdO/FZnzuGB1pOTyWZHnQ+pz6IlNhfhqBoxcQ8TQ+V+wIDAQAB");
_dmarc.l1-3.ephec-ti.be. 1800 IN TXT "v=DMARC1; p=reject; rua=mailto:contact@l1-3.ephec-ti.be"



;Server VPN
vpn	IN	A	164.92.131.165;

