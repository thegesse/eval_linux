#!/bin/bash


folder=$@

if [[ -z "$folder" || ! -d "$folder" ]]; then
	echo "Erreur dossier" >&2
	exit 1
fi

#creation dossier
mkdir -p range/{logs,csv,textes,images,divers}

#cp tt fichiers desorde -> range -> arrange them
#-v for debug
cp -vR ../desordre/* range/

#mv file to correct dir

while find range -mindepth 1 -type f | grep -q .; do
	#regex to get all file types and count them(debug)
	find range -type f | awk -F. 'NF>1 {print tolower($NF)}' | sort | uniq -c

#TODO fix here

	ext="${file##*.}"
	ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

	if [[ "$ext" == "png" ]]; then

	break
done
