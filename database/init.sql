USE woodytoys


CREATE TABLE `produit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prix` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);


CREATE USER 'b2b'@'10.0.0.2' IDENTIFIED BY 'password';
CREATE USER 'intranet'@'10.0.0.2' IDENTIFIED BY 'password';

GRANT SELECT ON woodytoys.produit TO 'b2b'@'10.0.0.2';
GRANT SELECT,INSERT ON woodytoys.produit TO 'intranet'@'10.0.0.2';

--
-- Déchargement des données de la table `produit`
--

INSERT INTO `produit` (`id`, `nom`, `prix`) VALUES
(1, 'toupie', 5),
(2, 'lego', 15),
(3, 'manette', 60);


CREATE DATABASE mail;

USE mail

CREATE USER 'mail'@'10.0.0.7' IDENTIFIED BY 'password';

GRANT SELECT,INSERT ON mail.* TO 'mail'@'10.0.0.7';

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `maildir` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

/* 
 * INSERT atelier, direction, contact, compta, commerciaux, secretariat
 */
INSERT INTO `users` (`username`, `password`, `email`, `maildir`) VALUES
('atelier', 'atelier', 'atelier@woodytoys.be', '/mail'),
('direction', 'direction', 'direction@woodytoys.be', '/mail'),
('contact', 'contact', 'contact@woodytoys.be', '/mail'),
('compta', 'compta', 'compta@woodytoys.be', '/mail'),
('commerciaux', 'commerciaux', 'commerciaux@woodytoys.be', '/mail'),
('secretariat', 'secretariat', 'secretariat@woodytoys.be', '/mail');

