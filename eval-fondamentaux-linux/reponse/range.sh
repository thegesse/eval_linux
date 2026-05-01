#!/bin/bash


folder=$@

if [[ -z "$folder" || ! -d "$folder" ]]; then
	echo "Erreur dossier" >&2
	exit 1
fi

#creation dossier
mkdir -p range/{logs,csv,textes,images,divers}

#cp tt fichiers desorde -> range -> arrange them
cp -vR ../desordre/* range/

#mv file to correct dir
find range -type f | while read -r file; do
	#regex to get all file types and count them(debug)
	find range -type f | awk -F. 'NF>1 {print tolower($NF)}' | sort | uniq -c

	shopt -s nocasematch

	if [[ "$file" =~ \.log$ ]]; then
		mv "$file" range/logs/		
	elif [[ "$file" =~ \.csv$ ]]; then
		mv "$file" range/csv/
	elif [[ "$file" =~ \.(txt|md)$ ]]; then
		mv "$file" range/textes/
	elif [[ "$file" =~ \.(png|jpg|jpeg)$ ]]; then
		mv "$file" range/images/
	else
		mv "$file" range/divers/
	fi

	shopt -u nocasematch
done
