#!/bin/bash

# Ustawienie liczby folderów i plików
#num_folders=5
#num_files=10


echo -e "::: Tworzenie losowych danych\n "  

if [ -z $1 ] || [ "$1" = "-h" ]; then
  echo -e "::: Uruchomienie skryptu:\n "
  echo "   generate_random_files.sh /tmp/directory "
  echo "                               ^           "
  echo "     parametr zawierajacy      | "
  echo -e "     katalog z losowymi danymi -  \n"
	exit
fi

# Sprawdzenie czy istnieje taki katalog
test -d "$1"
if [ $? -ne 0 ]; then
	echo "[ERROR]: Nie ma takiego katalogu!"
  echo -e "  Utworz go poleceniem:  mkdir $1 -p \n"
	exit
fi

# Przejscie do katalogu gdzie mają być losowe pliki
cd "$1"

echo -e "::: Odpowiedz na pytania: \n"

# Konfiguracja
echo "[Q]: Ile ma zostac utworzonych folderów?:"
read num_folders

echo "[Q]: Ile ma zostac maksymalnie plików w każdym folderze?:"
read num_files

echo "[Q]: Ile MB ma miec najwiekszy plik?:"
read num_mb



echo -e "::: Tworzenie losowych danych \n"

# Pętla tworząca losowe foldery
for ((i=1; i<=num_folders; i++))
do
  # Losowa nazwa folderu
  foldername=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

  # Tworzenie folderu
  mkdir $foldername

  # Pętla tworząca losowe pliki w folderze
  for ((j=1; j<=num_files; j++))
  do
    # Losowa nazwa pliku
    filename=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

    # Wielkość pliku
    filesize=$((RANDOM % $num_mb + 1))

    # Tworzenie pliku w folderze
    dd if=/dev/urandom of=$foldername/$filename bs=1M count=$filesize
  done
done


echo -e "\n\n::: [DONE] Losowe pliki zostały utworzone \n\n"

echo -e "::: [INFO] Rozmiar katalogu:"

du -h $1

