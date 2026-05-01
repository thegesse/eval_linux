#i!/bin/bash


folder=$@

if [[ -z "$folder" || ! -d "$folder" ]]; then
	echo "Erreur dossier" >&2
	exit 1
fi

#creation dossier + cp content
mkdir -p range/{logs,csv,textes,images,divers}
cp -vR ../desordre/* range/

find range -type f -print0 | while IFS= read -r -d '' file; do

	#format file
	new="$file"

	#lowercase, remove (), turn space to _, avoid repeat ___ 
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
		dir="range/logs/"		
	elif [[ "$file" =~ \.csv$ ]]; then
		dir="range/csv/"
	elif [[ "$file" =~ \.(txt|md)$ ]]; then
		dir="range/textes/"
	elif [[ "$file" =~ \.(png|jpg|jpeg)$ ]]; then
		dir="range/images/"
	else
		dir="range/divers/"
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
done
