<!DOCTYPE html>

<?php
# Connexion à la base de données
$db = mysqli_connect('10.2.0.2:3306', 'intranet', 'password', 'woodytoys') or die('Erreur de connection!');
?>

<html>

<head>
  <meta charset="UTF-8">
  <title>Site Web intranet WoodyToys</title>
</head>

<body>
  <h1>Site Web intranet WoodyToys</h1>

  <?php
  $query = "SELECT * FROM produit"; # Directive sql permettant de séléctionner tous les éléments de la table "produit".
  mysqli_query($db, $query) or die(mysqli_error($db));
  $affichage = mysqli_query($db, $query);

  # Boucle permettant l'affichage en "liste" des différents jouets présents dans la base de données.
  while ($row = mysqli_fetch_array($affichage)) {
    echo $row['id'] . ': ' . $row['nom'] . ' ' . $row['prix'] . ' <br />';
  }

  # Condition permettant lors du "submit" du boutton du formulaire html en dessous, d'envoyer les données rentrées dans ce formulaire dans la base de données.
  if (isset($_POST['submit'])) {

    $nom = $_POST["nom"]; # Définit les variables en fonction des valeurs rentrées pour nom et prix dans le formulaire avec la méthode POST.
    $prix = $_POST["prix"];

    $sql = "INSERT INTO produit (nom, prix) VALUES (?,?)"; # Directive sql permettant d'insérer un nouvel élément dans la table "jouets" de la base de données.
    $stmt = $db->prepare($sql);
    $stmt->bind_param("si", $nom, $prix); # Le premier paramètre de "bind_param()" ici "si" permet de spécifier le type de chacune des variables(s = string, i = integer).   
    $stmt->execute(); # Exécution de la dirctive sql.
  
  }

  mysqli_close($db);

  ?>

  <!-- Formulaire html d'ajout de jouets dans la base de données. -->
  <div style="float:right">
    <a>Ajouter un produits au catalogue</a><br><br>
    <form method="POST">
      nom:<br>
      <input type="text" name="nom"><br>
      prix:<br>
      <input type="number" name="prix"><br>
      <br><br>
      <input type="submit" name="submit" value="Envoyer">
    </form>
  </div>

</body>

</html>
