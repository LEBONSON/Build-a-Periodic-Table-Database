Instructions

Vous disposez d'une base de données de tableau périodique contenant des informations sur certains éléments chimiques. Vous pouvez vous y connecter en saisissant `psql --username=freecodecamp --dbname=periodic_table` dans le terminal. Il est conseillé de vous familiariser avec les tables, colonnes et lignes existantes. Lisez les instructions ci-dessous et complétez les scénarios utilisateurs pour terminer le projet. Certains tests peuvent ne pas être validés tant que d'autres scénarios utilisateurs ne sont pas terminés. Bonne chance !

Partie 1 : Corriger la base de données

La base de données contient des erreurs qui doivent être corrigées ou modifiées. Consultez les scénarios utilisateurs ci-dessous pour savoir quelles modifications apporter.

Partie 2 : Créer votre dépôt Git

Vous devez créer un petit programme Bash. Le code doit être versionné avec Git ; vous devrez donc transformer le dossier suggéré en dépôt Git.

Partie 3 : Créer le script

Enfin, vous devez créer un script qui accepte un argument sous la forme d'un numéro atomique, d'un symbole ou du nom d'un élément et qui affiche des informations sur cet élément. Dans votre script, vous pouvez créer une variable PSQL pour interroger la base de données comme ceci : `PSQL="psql --username=freecodecamp --dbname=<nom_de_la_base_de_données> -t --no-align -c"`. Ajoutez d'autres options si nécessaire.

Remarques :

Si vous quittez votre machine virtuelle, votre base de données risque de ne pas être sauvegardée. Vous pouvez en créer une copie en saisissant `pg_dump -cC --inserts -U freecodecamp periodic_table > periodic_table.sql` dans un terminal Bash (et non dans le terminal psql). Cette commande enregistrera les instructions pour reconstruire votre base de données dans le fichier `periodic_table.sql`. Ce fichier sera enregistré à l'emplacement où la commande a été saisie. S'il se trouve dans le dossier du projet, le fichier sera enregistré dans la machine virtuelle. Vous pouvez reconstruire la base de données en saisissant `psql -U postgres < periodic_table.sql` dans un terminal où se trouve le fichier `.sql`.

Si vous sauvegardez votre progression sur freeCodeCamp.org, après avoir réussi tous les tests, suivez les instructions ci-dessus pour sauvegarder votre base de données. Enregistrez le fichier periodic_table.sql, ainsi que la version finale de votre fichier element.sh, dans un dépôt public et soumettez son URL sur freeCodeCamp.org.

Veuillez effectuer les tâches suivantes :

Renommer la colonne « weight » en « atomic_mass ».

Renommer la colonne « melting_point » en « melting_point_celsius » et la colonne « boiling_point » en « boiling_point_celsius ».

Les colonnes « melting_point_celsius » et « boiling_point_celsius » ne doivent pas accepter de valeurs nulles.

Ajouter la contrainte UNIQUE aux colonnes « symbol » et « name » de la table « elements ».

Les colonnes « symbol » et « name » doivent avoir la contrainte NOT NULL.

Définir la colonne « atomic_number » de la table « properties » comme clé étrangère référençant la colonne du même nom dans la table « elements ».

Créer une table « types » qui stockera les trois types d’éléments.

La table « types » doit comporter une colonne « type_id » de type entier servant de clé primaire.

La table « types » doit comporter une colonne « type » de type VARCHAR ne pouvant pas être nulle. Elle stockera les différents types de la colonne « type » de la table « propriétés ».

Vous devez ajouter trois lignes à votre table « types », dont les valeurs correspondent aux trois types différents de la table « propriétés ».

Votre table « propriétés » doit comporter une colonne de clé étrangère « type_id » qui référence la colonne « type_id » de la table « types ». Cette colonne doit être de type INT avec la contrainte NOT NULL.

Chaque ligne de votre table « propriétés » doit avoir une valeur « type_id » liée au type correspondant dans la table « types ».

Vous devez mettre en majuscule la première lettre de toutes les valeurs de symboles dans la table « éléments ». Veillez à ne modifier que cette lettre et à ne pas toucher aux autres.

Vous devez supprimer tous les zéros non significatifs après la virgule de chaque ligne de la colonne « mass_atomique ». Vous devrez peut-être convertir le type de données en DECIMAL. Les valeurs finales se trouvent dans le fichier atomic_mass.txt.

Vous devez ajouter l'élément de numéro atomique 9 à votre base de données. Son nom est le fluor, son symbole est F, sa masse est de 18,998, son point de fusion est de -220 °C, son point d'ébullition est de -188,1 °C, et c'est un non-métal.

Vous devez ajouter l'élément de numéro atomique 10 à votre base de données. Son nom est le néon, son symbole est Ne, sa masse est de 20,18, son point de fusion est de -248,6 °C, son point d'ébullition est de -246,1 °C, et c'est un non-métal.

Vous devez créer un dossier `periodic_table` dans le dossier du projet et le convertir en dépôt Git avec `git init`.

Votre dépôt doit avoir une branche principale contenant tous vos commits.

Votre dépôt `periodic_table` doit contenir au moins cinq commits.

Vous devez créer un fichier `element.sh` dans le dossier de votre dépôt pour le programme que je vous demande de créer.

Votre script (.sh) doit être exécutable.

Si vous exécutez `./element.sh`, il doit afficher uniquement « Veuillez fournir un élément en argument. » et se terminer.

Si vous exécutez `./element.sh 1`, `./element.sh H` ou `./element.sh Hydrogen`, le résultat devrait être : « L'élément de numéro atomique 1 est l'hydrogène (H). C'est un non-métal, de masse 1,008 u.m.a. L'hydrogène a un point de fusion de -259,1 °C et un point d'ébullition de -252,9 °C.»

Si vous exécutez le script `./element.sh` avec un autre élément en entrée, vous devriez obtenir le même résultat, mais avec…
