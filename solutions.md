Parfait — c’est exactement le **projet “Periodic Table Database”** de freeCodeCamp.
Je vais te donner **les commandes SQL exactes** + **le script `element.sh`** conformes à tous les user stories.

---

## ✅ PARTIE 1 — Corriger la base de données

Connecte-toi d’abord :

```bash
psql --username=freecodecamp --dbname=periodic_table
```

---

### 1️⃣ Renommer les colonnes

```sql
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;
```

---

### 2️⃣ Contraintes NOT NULL sur melting / boiling

```sql
ALTER TABLE properties
ALTER COLUMN melting_point_celsius SET NOT NULL,
ALTER COLUMN boiling_point_celsius SET NOT NULL;
```

---

### 3️⃣ Contraintes UNIQUE + NOT NULL sur `elements`

```sql
ALTER TABLE elements
ALTER COLUMN symbol SET NOT NULL,
ALTER COLUMN name SET NOT NULL;

ALTER TABLE elements
ADD CONSTRAINT unique_symbol UNIQUE(symbol),
ADD CONSTRAINT unique_name UNIQUE(name);
```

---

### 4️⃣ Clé étrangère atomic_number

```sql
ALTER TABLE properties
ADD CONSTRAINT fk_atomic_number
FOREIGN KEY (atomic_number)
REFERENCES elements(atomic_number);
```

---

### 5️⃣ Créer la table `types`

```sql
CREATE TABLE types (
  type_id SERIAL PRIMARY KEY,
  type VARCHAR NOT NULL
);
```

---

### 6️⃣ Insérer les 3 types

```sql
INSERT INTO types(type)
SELECT DISTINCT type FROM properties;
```

---

### 7️⃣ Ajouter `type_id` à `properties` et  Ajouter FOREIGN KEY


```sql
ALTER TABLE properties ADD COLUMN type_id INT;

UPDATE properties
SET type_id = types.type_id
FROM types
WHERE properties.type = types.type;

ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

ALTER TABLE properties 
ADD CONSTRAINT fk_properties_type 
FOREIGN KEY (type_id) 
REFERENCES types(type_id);
```

---

### 8️⃣ Supprimer l’ancienne colonne `type`

```sql
ALTER TABLE properties DROP COLUMN type;
```

---

### 9️⃣ Capitaliser les symboles

```sql
UPDATE elements
SET symbol = INITCAP(symbol);
```

---

### 🔟 Corriger `atomic_mass` Mettre à jour pour supprimer les zéros de fin (supprimer zéros)

```sql
ALTER TABLE properties
ALTER COLUMN atomic_mass TYPE DECIMAL;

UPDATE properties
SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass::TEXT)::DECIMAL
WHERE atomic_mass::TEXT LIKE '%.%0';
```

Puis mets exactement les valeurs de `atomic_mass.txt` si nécessaire.

---

### 1️⃣1️⃣ Supprimer l’élément inexistant

```sql
DELETE FROM properties WHERE atomic_number = 1000;
DELETE FROM elements WHERE atomic_number = 1000;
```

---

### 1️⃣2️⃣ Ajouter Fluorine (9) et Neon (10)

```sql
INSERT INTO elements(atomic_number, symbol, name)
VALUES
(9, 'F', 'Fluorine'),
(10, 'Ne', 'Neon');

INSERT INTO properties
(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES
(9, 18.998, -220, -188.1, (SELECT type_id FROM types WHERE type='nonmetal')),
(10, 20.18, -248.6, -246.1, (SELECT type_id FROM types WHERE type='nonmetal'));
```

---

## ✅ PARTIE 2 — Git

```bash
mkdir periodic_table
cd periodic_table
git init
# First, create an initial commit
echo "# Periodic Table Project" > README.md
git add README.md
git commit -m "Initial commit"

# Now rename the branch
git branch -M main
```



➡️ Fais **au moins 5 commits** ensuite (`fix:`, `feat:` etc.)

---

## ✅ PARTIE 3 — Script `element.sh`

### Crée le fichier :

```bash
touch element.sh
chmod +x element.sh
```

---

### 📄 Contenu COMPLET de `element.sh`

```bash
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Aucun argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Recherche
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY="e.atomic_number=$1"
else
  QUERY="e.symbol='$1' OR e.name='$1'"
fi

RESULT=$($PSQL "
SELECT e.atomic_number, e.name, e.symbol, t.type,
       p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE $QUERY;
")

# Pas trouvé
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
```

---

## ✅ Tests attendus

```bash
./element.sh
# Please provide an element as an argument.

./element.sh 1
./element.sh H
./element.sh Hydrogen
# → sortie exacte demandée

./element.sh 999
# I could not find that element in the database.
```