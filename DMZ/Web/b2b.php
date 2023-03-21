<!DOCTYPE html>

<?php
# Connexion à la base de données
$db = mysqli_connect('10.0.0.6:3306', 'b2b', 'password', 'woodytoys') or die('Erreur de connection!');
?>

<html>

<head>
  <meta charset="UTF-8">
  <title>Site Web b2b WoodyToys</title>
</head>

<body>
  <h1>Site Web b2b WoodyToys</h1>

  <?php
  $query = "SELECT * FROM produit"; # Directive sql permettant de séléctionner tous les éléments de la table "produit".
  mysqli_query($db, $query) or die(mysqli_error($db));
  $affichage = mysqli_query($db, $query);

  # Boucle permettant l'affichage en "liste" des différents jouets présents dans la base de données.
  while ($row = mysqli_fetch_array($affichage)) {
    echo $row['id'] . ': ' . $row['nom'] . ' ' . $row['prix'] . ' <br />';
  }

  mysqli_close($db);

  ?>
</body>

</html>