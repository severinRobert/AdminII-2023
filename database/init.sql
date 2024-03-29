


USE woodytoys

--
-- Base de données : `woodytoys`
--

-- --------------------------------------------------------

--
-- Structure de la table `produit`
--

CREATE TABLE `produit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prix` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);


CREATE USER 'b2b'@10.2.0.1 IDENTIFIED BY 'password';
CREATE USER 'intranet'@10.2.0.1 IDENTIFIED BY 'password';
GRANT SELECT ON woodytoys.produit TO 'b2b'@10.2.0.1;
GRANT SELECT,INSERT ON woodytoys.produit TO 'intranet'@10.2.0.1;


--
-- Déchargement des données de la table `produit`
--

INSERT INTO `produit` (`id`, `nom`, `prix`) VALUES
(1, 'toupie', 5),
(2, 'lego', 15),
(3, 'manette', 60);