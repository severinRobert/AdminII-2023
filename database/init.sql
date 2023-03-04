
CREATE DATABASE woodytoys;

GRANT SELECT ON woodytoys.produit TO 'b2b'@'%';
GRANT SELECT,INSERT ON woodytoys.* TO 'interne'@'%';

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

--
-- Déchargement des données de la table `produit`
--

INSERT INTO `produit` (`id`, `nom`, `prix`) VALUES
(1, 'toupie', 5),
(2, 'lego', 15),
(3, 'manette', 60);