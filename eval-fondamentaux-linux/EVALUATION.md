# Évaluation - Fondamentaux de Linux

# Partie I - Théorie (10 points)

## Q1 - Vocabulaire (2 pt)

Définissez **en une phrase chacun** les termes suivants :

1. shell
2. prompt
3. terminal
4. kernel

## Q2 - Que fait `awk` (1 pt)

Expliquez ce que fait la commande ci-dessous, ligne par ligne, et décrivez le format de la sortie :

```bash
awk -F: '{print $1}' /etc/passwd | sort | head -5
```

## Q3 - Que fait `cut` (1 pt)

Expliquez ce que fait la commande ci-dessous, et donnez la forme exacte de la sortie pour un fichier `ventes.csv` qui contient `id,produit,quantite,prix` en en-tête :

```bash
cut -d, -f2,4 ventes.csv | sort -u
```

## Q4 - Que fait `sed` (1 pt)

Expliquez ce que fait la commande ci-dessous, et indiquez si le fichier `app.log` est modifié ou non :

```bash
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' app.log
```

## Q5 - Regex (1,5 pt)

Soit la regex étendue : `^[A-Z]{2,3}-[0-9]{4}(-v[0-9]+)?$`

1. Décrivez en français ce qu'elle accepte.
2. Donnez 2 chaînes qui matchent et 2 chaînes qui ne matchent pas.
3. Avec quelle option de `grep` doit-on l'utiliser pour qu'elle soit interprétée comme ci-dessus ? Pourquoi ?

## Q6 - Permissions (1 pt)

Un collègue vous dit : "j'ai fait `chmod 777` sur le dossier de l'application, maintenant ça marche". Donnez deux raisons techniques pour lesquelles c'est une mauvaise réponse, et la démarche à suivre à la place.

## Q7 - Redirections (1 pt)

Soit la commande `mon-script.sh` qui écrit à la fois sur stdout et stderr.

1. Comment rediriger uniquement les erreurs vers `erreurs.log`, en gardant la sortie normale à l'écran ?
2. Comment rediriger les deux flux dans le même fichier `tout.log` ?

## Q8 - Pipeline canonique (1 pt)

Expliquez ce que produit cette commande sur un fichier de logs Apache, **étape par étape**, en disant le rôle de chaque maillon du pipe :

```bash
awk '{print $1}' web.log | sort | uniq -c | sort -rn | head -3
```

## Q9 - `grep` vs `find` (0,5 pt)

En une phrase, quelle est la différence fondamentale entre `grep` et `find` ?

---

# Partie II - Script de rangement (10 points)

## Contexte

Le dossier `desordre/` (livré avec ce sujet) contient une trentaine de fichiers en vrac : logs, csv, textes, images, et autres. Les noms sont sales : majuscules, espaces, parenthèses, points d'exclamation, accents.

Vous devez écrire un script `range.sh` qui range ce dossier proprement, normalise les noms et produit un rapport.

## Cahier des charges

### 1. Interface

- Le script s'appelle `range.sh` et se lance ainsi :

  ```bash
  ./range.sh desordre/
  ```

- Si l'argument est absent ou si le chemin n'existe pas (ou n'est pas un dossier), le script doit afficher un message d'erreur **sur stderr** et sortir avec un code de retour non nul.

### 2. Structure de rangement

Le script crée, dans le dossier courant, l'arborescence suivante :

```
range/
  logs/       # fichiers .log
  csv/        # fichiers .csv
  textes/     # fichiers .md et .txt
  images/     # fichiers .png, .jpg, .jpeg
  divers/     # tout le reste (y compris fichiers sans extension)
```

L'extension est détectée **sans tenir compte de la casse** : `.LOG` va dans `logs/`, `.JPG` dans `images/`.

### 3. Normalisation des noms

Pour chaque fichier déplacé, le nom de destination doit :

1. être entièrement en minuscules ;
2. avoir tous les caractères autres que `[a-z0-9._-]` remplacés par `_` (un caractère source -> un underscore) ;
3. ne pas contenir deux `_` consécutifs (les compresser en un seul) ;
4. ne pas avoir de `_` collé à un `.` (ni `_.` ni `._`) ;
5. ne ni commencer ni finir par `_` ou `.`.

Exemples obligatoires (aident à fixer le comportement attendu) :

| Avant | Après |
| --- | --- |
| `Mon Rapport Final.md` | `mon_rapport_final.md` |
| `Auth-FAILED.LOG` | `auth-failed.log` |
| `selfie (final).jpeg` | `selfie_final.jpeg` |
| `  fichier avec espaces  .txt` | `fichier_avec_espaces.txt` |

### 4. Collisions

Si un fichier de même nom normalisé existe déjà dans le dossier de destination, suffixez-le avec `_1`, puis `_2`, etc., avant l'extension.

Exemple : si `notes.md` existe, le suivant devient `notes_1.md`, puis `notes_2.md`.

### 5. Rapport

Le script génère `range/rapport.md` qui contient au minimum :

- la date de génération au format ISO (avec heure) ;
- le chemin absolu du dossier source traité ;
- un tableau Markdown avec une ligne par catégorie et le nombre de fichiers rangés ;
- le total général ;
- la liste complète des déplacements effectués, au format `ancien chemin -> nouveau chemin`.

Format suggéré :

```markdown
# Rapport de rangement

- Date : 2026-04-30T11:45:02+02:00
- Source : /home/etudiant/desordre

| Categorie | Nombre |
| --- | ---: |
| logs | 4 |
| csv | 3 |
| ...

Total : 26 fichiers

## Deplacements

- desordre/ssh access.log -> range/logs/ssh_access.log
- ...
```

### 6. Robustesse exigée

Le script doit obligatoirement :

- commencer par un shebang correct ;
- utiliser au moins **une fois** un test regex avec `[[ ... =~ ... ]]` ;
- poser un `trap` qui, en cas d'erreur ou de `ctrl-c`, écrit un message sur stderr (le rapport partiel peut rester) ;
- ne pas modifier le dossier source : les fichiers doivent être **déplacés** depuis `desordre/` vers `range/`. À la fin, `desordre/` est vide ;
- fonctionner avec des noms de fichiers contenant des espaces et des caractères accentués.

### 7. Idempotence

Si on relance le script une deuxième fois sur un nouveau dossier source, le `range/` existant ne doit pas être détruit : les nouveaux fichiers s'ajoutent et la règle de collision s'applique.

## Test rapide

Pour vérifier votre script avant de rendre :

```bash
./range.sh desordre/
ls range/
cat range/rapport.md
find range -type f | wc -l   # doit valoir le nombre initial dans desordre/
ls desordre/                 # doit être vide
```

## Pistes de réflexion

- Découpez le problème en **4 étapes indépendantes** : lister les fichiers, normaliser un nom, choisir la catégorie, déplacer + journaliser. Chaque étape peut se tester seule.
- Affichez **avant** de modifier. Construisez d'abord une boucle qui imprime `ancien -> futur nom` sans rien déplacer. Ne passez au `mv` qu'une fois la sortie correcte.
- Toutes les commandes dont vous avez besoin ont été vues en cours (J2 surtout). Si vous êtes tenté d'utiliser un outil que vous n'avez jamais vu en TP, c'est probablement le mauvais outil.
- La normalisation peut s'écrire en chaînant plusieurs petites transformations dans un pipe. Résistez à la regex unique qui fait tout d'un coup.
- Pour la collision de noms : un compteur et une boucle qui teste l'existence d'un chemin avec `[[ ... ]]`.
- Pour le rapport : décidez d'abord du format final sur papier, puis écrivez-le en une seule passe à la fin (vous avez déjà toutes les données en mémoire).
- Si vous êtes bloqué sur un point, **passez au suivant** et revenez à la fin. Un script qui couvre 80% du sujet vaut mieux qu'un script parfait pour la moitié.
- Ne supprimez jamais le `desordre/` pour "recommencer plus vite" : copiez-le avant (`cp -r desordre desordre.bak`).

## Ressources à votre disposition

En plus de vos notes de cours :

- `man <commande>` et `<commande> --help` : la documentation officielle de la machine.
- `https://devhints.io/bash` : cheatsheet bash (variables, tests, redirections).
- `https://explainshell.com/` : copier une commande, lire ce que fait chaque option.
- `https://regex101.com/` ou `https://regexr.com/` : tester une regex avec mise en valeur des matches. Choisir la saveur **POSIX ERE** pour rester proche de `grep -E` / `sed -E`.
- `https://www.shellcheck.net/` : linter qui pointe les erreurs courantes dans un script bash. Très utile en relecture.

---

Bonne chance.
