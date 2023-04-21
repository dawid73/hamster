#!/bin/bash

# TODO dodaj jakis opis

# pierwszy parametr
# $1 1 - wysylanie ; 2 - pobieranie
# $2 local_file
# $3 remote_user
# $4 remote_server
# $5 remote_path
# $6 remote_port

echo -e "::: Synchronizacja rsync katalogów pomiedzy serwerami \n "  
echo -e "    run_sync.sh [1-send 2-download] [katalog_lokalny] [zdalny_uzytkownik] [zdalny_serwer] [zdalny_katalog] [port_ssh(opcjonalnie)]\n"
echo -e "    przyklad: run_sync.sh 2 /root/backups user1 server1 /home/backup 2222\n\n"
echo -e "[UWAGA!!] musisz miec dostep do zdalnego serwera z wykorzystaniem kluczy SSH (bez hasła)\n"

if [[ $1 -ne 1 && $1 -ne 2 ]]; then
  echo "[ERROR]: Pierwszy parametr musi być równy 1 lub 2 !!"
  exit
fi

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
  echo "[ERROR]: Nie podano wszystkich parametrów !"
  exit
fi

remote="$3@$4:$5"
local=$2

# Sprawdzenie czy istnieje taki katalog
test -d "$local"
if [ $? -ne 0 ]; then
	echo "[ERROR]: Nie ma takiego katalogu na serwerze"
	exit
fi

port=""

if [[ -n "$6" && "$6" =~ ^[0-9]+$ ]]; then
  port="-e ssh -p $6"
else
  port=""
fi

echo -e "::: Synchornizuje katalogi pomiedzy serwerami: "

if [ "$1" = "1" ]; then
  echo "Z katalogu: $local"
  echo "Do katalogu: $remote"
  rsync -a $port --delete $local $remote
fi 
if [ "$1" = "2" ]; then
  echo "Z katalogu: $remote"
  echo "Do katalogu: $local"
  rsync -a $port --delete $remote $local
fi 

if [ $? -eq 0 ]; then
  echo -e "\n[DONE]: Synchornizacja powiodla się !"
else
  echo -e "\n[ERROR]: Wystapil blad"
  #TODO dopisac obsluge bledu
fi
