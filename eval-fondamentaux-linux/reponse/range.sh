#!/bin/bash

folder=$@

if [[ -z "$folder" || ! -d "$folder" ]]; then
	echo "Erreur dossier" >&2
	exit 1
fi

base_dir="range"

#creation dossier + cp content
mkdir -p "$base_dir"/{logs,csv,textes,images,divers}

logs=0
csv=0
textes=0
images=0
divers=0

move_files=$(mktemp)

while IFS= read -r -d '' file; do
	#format file
	base="$(basename "$file")"
	new="$base"

	#lowercase, remove (), turn space to _, avoid repeat ___ 
	new="${new,,}"
	new="${new//[()]/}"
	new="${new// /_}"
	new="$(sed 's/_\+/_/g' <<< "$new")"

	if [[ "$base" != "$new" ]]; then
		mv "$file" "$(dirname "$file")/$new"
		file="$(dirname "$file")/$new"
	fi	

	#mv files
	if [[ "$new" =~ \.log$ ]]; then
		dir="$base_dir/logs/"		
		((logs++))
	elif [[ "$new" =~ \.csv$ ]]; then
		dir="$base_dir/csv/"
		((csv++))
	elif [[ "$new" =~ \.(txt|md)$ ]]; then
		dir="$base_dir/textes/"
		((textes++))
	elif [[ "$new" =~ \.(png|jpg|jpeg)$ ]]; then
		dir="$base_dir/images/"
		((images++))
	else
		dir="$base_dir/divers/"
		((divers++))
	fi

	#persistance n numbers or sumn
	mkdir -p "$dir"
	 base="$(basename "$file")"
	 if [[ "$base" == *.* ]]; then
		 name="${base%.*}"
		 name="$(sed 's/_[0-9]\+$//' <<< "$name")"
		 ext=".${base##*.}"
	else
		name="$base"
		ext=""
	fi

	target="$dir/$name$ext"

	i=1
	while [[ -e "$target" ]]; do
		target="$dir/${name}_$i$ext"
		((i++))
	done
	mv "$file" "$target"
	echo "- $file -> $target" >> "$move_files"
done < <(find "$folder" -type f -print0)

#marking down the markdown file
base_dir="range"
mkdir -p "$base_dir"

cat > "$base_dir/rapport.md" <<EOF
#Rapport de rangement

-Date : $(date +"%d/%m/%Y %H:%M:%S")
-source : $folder

#Repartition

| Catégorie | Nombre |
| --- | ---: |
| logs | $logs |
| csv | $csv |
| textes | $textes |
| images | $images |
| divers | $divers |

Total : $((logs + csv + textes + images + divers)) fichiers

#Deplacements

$(cat "$move_files")
EOF

rm "$move_files"




