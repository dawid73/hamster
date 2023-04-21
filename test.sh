#!/bin/bash

# TODO Dodaj komentarz i autora 

string="przykładowy/string/z/kilku/slashy/"
string_with_dash="${string//\//-}"
echo $string_with_dash

sleep 10

logger "Wiadomosc do zapinia w logu"
printf "Wiadomość do zapisania w logach" >> ./info.log