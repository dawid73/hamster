#!/bin/bash

# TODO dodaj jakis opis

echo -e "::: Tworzenie archiwum .tar.gz \n "  
echo -e "    run_backup.sh [katalog_docelowy] [katalog_do_spakowania] [starsze_niż_dni_do_usuniecia (opcjonalne)]\n"
echo -e "    przyklad: run_backup.sh /root/backups /var/www/wordpress 30 \n"

# Sprawdzenie czy podano parametr z katalogiem
if [ -z $1 ]; then
	echo "[ERROR]: Nie podano katalogu docelowego!"
	exit
fi

if [ -z $2 ]; then
	echo "[ERROR]: Nie podano katalogu do spakowania!"
	exit
fi

# Sprawdzenie czy istnieje taki katalog
test -d "$1"
if [ $? -ne 0 ]; then
	echo "[ERROR]: Nie ma takiego katalogu docelowego!"
	exit
fi

test -d "$2"
if [ $? -ne 0 ]; then
	echo "[ERROR]: Nie ma takiego do archiwizacji!"
	exit
fi

backup_path=$1
full_path=$2


path_with_dash="${full_path//\//-}"
if [[ $path_with_dash == -* ]]; then
	path_with_dash="${path_with_dash#-}"
fi

# podkatalog sciezki do folderu do spakowania
dir=$(dirname $full_path)

# nazwa katalogu do spakowania
base=$(basename $full_path)

# tylko sciezka do katalogu backup
backup=$(echo "$backup_path" | sed 's/\/$//')

filename=backup-$path_with_dash$(date +%Y%m%d).tar.gz

echo -e "::: Tworzenie archiwum .tar.gz \n "
echo -e "    $full_path --> $backup_path$filename" 

tar -zcf $backup/$filename -C $dir/ $base

if [ $? -eq 0 ]; then
	echo -e "\n \n[DONE]: Tworzenie archiwum zakończyło się sukcesem"
	echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Creating an archive of the folder: $full_path to the $backup_path location was successful." >> ./info.log
else
	echo -e "\n \n [ERROR]: Tworzenie archiwum zakończyło się błędem"
	echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] Creating an archive of the folder: $full_path to the $backup_path location failed to complete successfully." >> ./info.log
fi
echo -e "\n[INFO]: Rozmiar archiwum:\n "
ls -lh $backup_path$filename

if [[ -n "$3" && "$3" =~ ^[0-9]+$ ]]; then
	echo -e "::: Usuwanie plików starszych niż $3 dni\n "
	find $backup/* -mtime +$3 -delete
fi

echo -e "\n" >> ./info.log
