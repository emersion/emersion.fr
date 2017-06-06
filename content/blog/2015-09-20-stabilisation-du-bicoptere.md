+++
date = "2015-09-20T00:00:00+02:00"
title = "Stabilisation du bicoptère"
slug = "stabilisation-du-bicoptere"
lang = "fr"
+++

Pendant les vacances scolaires, notre équipe a pu travailler et bien avancer sur plusieurs points.

* La structure du quadcopter : elle a été construite en bois, avec amour. Elle n'est pas encore utilisée pour l'instant :  on se concentre encore sur l'étude du bicoptère.

  ![Structure du quadcopter](/img/blog/2015-stabilisation-du-bicoptere/quad-struct.jpg)

* L'étude physique : les résultats ont été analysés plus en profondeur, afin d'améliorer notre modèle physique et de mieux prendre en compte les frottements.

* La stabilisation : un nouveau stabilisateur a été créé et semble marcher plutôt bien.

Ce billet traitera principalement de la stabilisation, étant donné que je m'en suis chargé.

## Stabilisateur en position

Je vous avais parlé d'un stabilisateur _en vitesse_ dans [mon dernier billet](/blog/2015/premieres-experimentations-sur-le-bicoptere/). Ce dernier marchait mal, c'est ce qui m'a poussé à aller plus loin et créer un stabilisateur _en position_.

Le stabilisateur en position utilise non seulement les données du gyromètre (qui mesure la vitesse angulaire) comme le stabilisateur en vitesse, mais aussi les données de l'accéléromètre (qui permet de déterminer la position angulaire). Le pilote commande alors l'engin en inclinaison de chaque axe, il s'agit d'un mode _stabilisé_ et non _acrobatique_.

Vous vous rappelez du stabilisateur _en vitesse_ qui utilisait un [<abbr title="Proportionnel-Intégral-Dérivé">PID</abbr>](https://fr.wikipedia.org/wiki/R%C3%A9gulateur_PID) ?

![](/img/blog/2015-stabilisation-du-bicoptere/pid-rate.png)

Eh bien, le stabilisateur _en position_ en utilise deux ! On a un angle de commande qui vient du pilote, et une mesure de l'angle actuel qui vient du capteur. Un premier PID calcule la correction à apporter pour atteindre l'objectif. De même, un deuxième PID se charge de calculer la correction à apporter au niveau de la vitesse angulaire.

![](/img/blog/2015-stabilisation-du-bicoptere/pid-stabilized.png)

## Détermination de la position angulaire à partir de l'accélération

L'accéléromètre mesure des... accélérations ! Mais comme dit plus haut, on peut en déduire l'inclinaison de l'engin (donc des angles). Comment est-ce possible ?

Prenons notre capteur, et posons-le sur une table, avec quatre pieds de préférence (histoire qu'elle soit bien immobile).

![](/img/blog/2015-stabilisation-du-bicoptere/accel-no-angle.png)

Lorsque l'accéléromètre est horizontal, la Terre exerce une force de poussée vers le bas sur le capteur : c'est le poids. L'accéléromètre est capable de mesurer son poids selon trois axes (x, y, et z). Pour chaque axe, il renvoie une mesure : on notera _a<sub>x</sub>_ la mesure de l'axe x, _a<sub>y</sub>_ et _a<sub>z</sub>_ pour y et z. Les mesures renvoyées sont dans une unité spéciale : g. Lorsque le capteur renvoie 1g pour un axe, c'est que tout le poids s'exerce sur cet axe.

Ici, le poids tire uniquement vers le bas : le capteur va renvoyer _a<sub>x</sub>_ = 0g et _a<sub>y</sub>_ = 1g.

Bon, maintenant on coupe deux pieds de la table (à la hache, on fait les choses proprement ici), et tant bien que mal elle devient penchée.

![](/img/blog/2015-stabilisation-du-bicoptere/accel-with-angle.png)

Le poids tire toujours vers la Terre, donc vers le bas. Seulement, comme le capteur est penché, les axes de mesure de l'accéléromètre sont penchés eux aussi. Du point de vue du capteur, le poids tire _un peu_ sur l'axe x et _pas mal_ sur l'axe y. Ce _un peu_ et _pas mal_ peuvent être précisés à l'aide d'un peu de trigonométrie : il est possible de relier la valeur de l'angle entre l'axe x et le poids avec _a<sub>x</sub>_ et _a<sub>y</sub>_.

![](/img/blog/2015-stabilisation-du-bicoptere/accel-maths.png)

Si on nomme &alpha; l'angle entre l'axe x et le poids, on trouve _a<sub>x</sub>_ = cos &alpha; et _a<sub>y</sub>_ = sin &alpha;. Ces deux infos nous suffisent pour déterminer &alpha; en fonction de _a<sub>x</sub>_ et _a<sub>y</sub>_. C'est bon, on connaît l'angle !

## Résultats et avenir

[![Résultats](/img/blog/2015-stabilisation-du-bicoptere/resultat.jpg)](https://youtu.be/D9KkUSiNNaU?t=17s)

<p class="text-center"><em>"On peut véritablement parler de RÉSULTAT !"</em></p>

Après un réglage grossier des différentes constantes des deux PID, le bicoptère est enfin stable ! On peut lui envoyer un angle de commande, il va l'atteindre et s'y tenir. Si l'on déclenche une perturbation (petite pichnette sur l'axe), la puissance des moteurs est ajustée afin de revenir à l'angle de consigne.

Il faut aussi dire que la stabilité du bicoptère est favorisée par le poids de la batterie en-dessous de l'axe, qui tend à ramener l'engin dans sa position d'équilibre (dans le cas où le pilote n'envoie pas un angle de commande). Il faudrait mettre le poids au-dessus de l'axe, ainsi à chaque perturbation le poids va avoir tendance à retourner le bicoptère, et le stabilisateur devra ajuster la puissance des moteurs afin d'éviter ça (un quadcoptère qui vole à l'envers, c'est pas cool).

Enfin, l'ajustement des constantes des PID est un sujet épineux. C'est possible de le faire expérimentalement en testant plusieurs valeurs jusqu'à obtenir un résultat viable, mais ce n'est pas très précis et long. Nous allons donc faire des simulations informatiques : créer un modèle qui reproduira le comportement du bicoptère grâce aux études physiques déjà faites, et tester un grand nombre de valeurs pour les constantes du PID. On verra ensuite comment le système réagit : si l'angle de commande est atteint, au bout de combien de temps, si ça oscille autour de l'angle sans se stabiliser, etc... On pourra donc déterminer les meilleures constantes pour le PID.

Et ensuite on pourra attaquer la stabilisation du quadcopter à proprement parler ! :-P
