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
	  "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs592qfx9BlwUTOHf3zo7ixM7za4seMKMymjNxNlHdcvAYhkgQZ845hfplLHDyGHcibRnTMnktI0z/PNV8YXRcQOm4JUj70N0NmIhLzw11ha6Serxrs/FVR/Q19045F0ZDW/Run+6H5lO2vKnVQFM331Dnd1dEi+1yfR71ESx92RSmkjvUUyowib57F8CC/Q1OZbOBrGs1HWpPD"
	  "iU7y1GdNMATkSWm/ycFexjNg1XnAcHpCjAgMnhPVrBauk2kldrr/rwlfISijsE+WCcmrWp7edgV4IJ/9pCzxj6C+PWti4cv6yS6d4WX9ocbURIKcnznEEr8TlxozcB1dYPE4HqvQIDAQAB" )  ;
_dmarc.l1-3.ephec-ti.be. 1800 IN TXT "v=DMARC1; p=reject; rua=mailto:contact@l1-3.ephec-ti.be"



;Server VPN
vpn	IN	A	164.92.131.165;

