Voici une **version README en anglais**, prête à être utilisée telle quelle dans ton dépôt (`README.md`).
Le contenu est fidèle à ce que tu as fourni, simplement **traduit, clarifié et structuré** au format attendu pour un projet freeCodeCamp.

---

# Periodic Table Database Project

This project is part of the **freeCodeCamp Relational Database Certification**.
It consists of fixing an existing PostgreSQL database, normalizing its structure, and creating a Bash script that queries the database to display information about chemical elements.

---

## Part 1 — Fixing the Database

First, connect to the database:

```bash
psql --username=freecodecamp --dbname=periodic_table
```

---

### 1. Rename Columns

```sql
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;
```

---

### 2. Add NOT NULL Constraints to Melting and Boiling Points

```sql
ALTER TABLE properties
ALTER COLUMN melting_point_celsius SET NOT NULL,
ALTER COLUMN boiling_point_celsius SET NOT NULL;
```

---

### 3. Add UNIQUE and NOT NULL Constraints to `elements`

```sql
ALTER TABLE elements
ALTER COLUMN symbol SET NOT NULL,
ALTER COLUMN name SET NOT NULL;

ALTER TABLE elements
ADD CONSTRAINT unique_symbol UNIQUE(symbol),
ADD CONSTRAINT unique_name UNIQUE(name);
```

---

### 4. Add Foreign Key on `atomic_number`

```sql
ALTER TABLE properties
ADD CONSTRAINT fk_atomic_number
FOREIGN KEY (atomic_number)
REFERENCES elements(atomic_number);
```

---

### 5. Create the `types` Table

```sql
CREATE TABLE types (
  type_id SERIAL PRIMARY KEY,
  type VARCHAR NOT NULL
);
```

---

### 6. Insert the Three Element Types

```sql
INSERT INTO types(type)
SELECT DISTINCT type FROM properties;
```

---

### 7. Add `type_id` to `properties` and Create Foreign Key

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

### 8. Remove the Old `type` Column

```sql
ALTER TABLE properties DROP COLUMN type;
```

---

### 9. Capitalize Element Symbols

```sql
UPDATE elements
SET symbol = INITCAP(symbol);
```

---

### 10. Fix `atomic_mass` Values (Remove Trailing Zeros)

```sql
ALTER TABLE properties
ALTER COLUMN atomic_mass TYPE DECIMAL;

UPDATE properties
SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass::TEXT)::DECIMAL
WHERE atomic_mass::TEXT LIKE '%.%0';
```

Ensure the final values match those provided in `atomic_mass.txt`.

---

### 11. Remove the Non-Existent Element

```sql
DELETE FROM properties WHERE atomic_number = 1000;
DELETE FROM elements WHERE atomic_number = 1000;
```

---

### 12. Add Fluorine (9) and Neon (10)

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

## Part 2 — Git Repository Setup

```bash
mkdir periodic_table
cd periodic_table
git init

# Create the initial commit
echo "# Periodic Table Project" > README.md
git add README.md
git commit -m "Initial commit"

# Rename the branch to main
git branch -M main
```

After that, create **at least five additional commits**.
All commit messages (except the first) must start with one of the following prefixes:

* `fix:`
* `feat:`
* `refactor:`
* `chore:`
* `test:`

---

## Part 3 — Bash Script (`element.sh`)

### Create the Script File

```bash
touch element.sh
chmod +x element.sh
```

---

### Full Content of `element.sh`

```bash
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# No argument provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Search by atomic number or by symbol/name
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

# Element not found
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
```

---

## Expected Script Behavior

```bash
./element.sh
# Please provide an element as an argument.

./element.sh 1
./element.sh H
./element.sh Hydrogen
# Correct element information is displayed

./element.sh 999
```

---
