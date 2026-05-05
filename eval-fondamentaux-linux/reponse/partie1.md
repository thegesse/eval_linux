Q1

1. Un shell est un interpreteur de commande, il sert d'intermediere entre le user et le system
2. Un prompt est un affichage dans le terminal qui indique que l'on peut entrer des commandes
3. Un terminal est une interface qui permet a l'utilisateur d'entrer des commandes et de voir les resultat
4. Un Kernel est le noyeaux de l'os il sert d'intermediere entre le system et les components du pc


Q2

AWK parcour un fichier ligne par ligne en separent les donnees, -F: indique que on separe aved :, le print $1 veut dire que l'on affiche que la 1er colone de la ligne actuelle, apres on indique le path du fichier

Q3

La commende separe le fichier vente.csv en un tableau de 4 colomnes puis recuperes la colone 2, et 4, et les donnes sous forme d'un tableau produit,prix en ordre alphabetique sans double

Q4

Lq commande remplace les IP avec un string IP dans le fichier app.log, et le fichier ne sera pas modifier car la commande s'effectue sur un copie du fichier app.log

Q5

1. La regex accepte les chaine de characters avec 2/3 lettres majuscule de A a W suivie de - ensuite 4 chiffre entre 0-9, suivi de -v et finallement d'un chiffre de 0-9
2. correcte: AB-1234 et XYZ-5678-v2
    incorrecte: A-1234 et AB-123-v1
3. On utilise -E car la regex utilise des expressions etendues ({2,4} par exemple)

Q6

La commandes donne l'autorisation a tout le mondes d'ecrire, d'executer et de lire tout le projet ce qui n'est pas conseiller pour la securiter du projet, et aussi la commande ne change pas les permissions des autres fichier sans -r donc le problem n'etais peut etre pas le manque de permission. A la place on fait chmod avec les perms manquant sur les fichier qui n'ont pas l'autorisation necessaire pour faire fonctionner l'application

Q7

1. 2>
2. > ou >>

Q8

Le awk {print $1} web.log va récupérer toute les addresses ip
Le sort va trie les ip.
Le uniq -c va retire les ip en double et compté combien de fois cette ip apparait.
Le sort -rn va trie de facon numerique dans l'ordre décroissant.
Le head -3 va recuperer les 3 premieres ip qui apparaisse le plus.

Q9

grep s'execute sur des chaines de char ou des fichier et find s'execute sur des nom de fichier ou dossier

