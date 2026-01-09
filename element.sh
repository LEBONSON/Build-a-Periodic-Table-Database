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

# Pas trouvé le resultat
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
