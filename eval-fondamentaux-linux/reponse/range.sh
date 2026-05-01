#!/bin/bash


folder=$@

if [[ -z "$folder" || ! -d "$folder" ]]; then
	echo "Erreur dossier" >&2
	exit 1
fi

#creation dossier + cp content
mkdir -p range/{logs,csv,textes,images,divers}
cp -vR ../desordre/* range/

find range -type f | while read -r file; do
	#format file
	new="$file"

	#lowercase, remove (), turn space to _
	new="${new,,}"
	new="${new//[()]/}"
	new="${new// /_}"
	new="$(sed 's/_\+/_/g' <<< "$new")"

	if [[ "$file" != "$new" ]]; then
		mv "$file" "$new"
		file="$new"
	fi	

	#mv files
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
done
