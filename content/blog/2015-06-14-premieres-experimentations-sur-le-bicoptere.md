+++
date = "2015-06-14T00:00:00+02:00"
title = "Premières expérimentations sur le bicoptère"
lang = "fr"
+++

Depuis mon [dernier article](/blog/2015/shopping-et-propeller-attack/), nous avons construit le bicoptère à bascule qui nous servira de plateforme de test pour la stabilisation de l'appareil. Cet appareil est constitué d'un axe auquel sont fixés deux hélices. Ainsi, on va pouvoir mettre les gaz à fond sans risquer de tout casser ! (Bon, jusqu'au moment où ce sont les hélices qui partent, mais ça c'est une autre histoire...)

[![Bicoptère, premier prototype](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/bicoptere-first-thumbnail.jpg)](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/bicoptere-first.jpg)

## Force de poussée du moteur

Nous avons déjà mis au point un modèle physique du bicoptère et nous avons pu trouver la relation entre la force de poussée des hélices l'accélération angulaire de l'axe. Pour aller plus loin dans notre modèle, il nous manquait la relation entre la vitesse des moteurs et la force de poussée des hélices. Cette relation n'est pas simple car elle dépend d'un certain nombre de facteurs, comme la longeur des hélices, leur angle, leur surface, leur forme, ~~leur couleur~~... Nous avons donc décidé de déterminer expérimentalement cette relation.

Depuis le Raspberry Pi, on contrôle la vitesse des moteurs en envoyant un signal [<abbr title="Pulse-Width Modulation">PWM</abbr>](https://fr.wikipedia.org/wiki/Modulation_de_largeur_d'impulsion). Le Raspberry Pi, à intervalle régulier, envoie une pulsation aux ESC (les contrôleurs de vitesse des moteurs). C'est la longueur de la pulsation qui détermine la vitesse du moteur.

![Principe du PWM](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/pwm.gif)

<p class="text-center"><em>Moteur éteint, moteur qui tourne et moteur qui tourne très très vite !</em></p>

Nous avons donc relié l'une des extrémités du bicoptère à des poids avec une corde passant par une poulie. De l'autre extrémité, on a fait tourner l'hélice. Ainsi, on peut envoyer un signal au moteur puis ajuster la masse pendue au fil pour équilibrer l'axe. La masse à l'équilibre nous donne la masse que pourrait soulever l'hélice, à partir de celle-ci on peut obtenir la force de poussée de l'hélice en newtons (avec la relation _f = m · g_, merci Newton !).

[![Détermination de la force de poussée des hélices](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/bicoptere-mass-exp-thumbnail.jpg)](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/bicoptere-mass-exp.jpg)

On peut alors tracer sur un graphe la masse soulevée en fonction de la largeur des pulsations envoyées :

![Force de poussée des hélices en fonction du signal](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/bicoptere-mass-results.png)

On obtient entre 1,1 et 1,45 ms une courbe que l'on pourra approximer par une droite.

## Tests pour le stabilisateur

Nous avons ensuite testé un prototype de stabilisateur sur le bicoptère. Nous avons donc construit une petite nacelle pour accueillir la batterie et le Raspberry Pi que l'on a tout d'abord fixée en bas de l'axe. Ainsi, dans un premier temps la stabilisation serait favorisée par la position de la nacelle : l'axe tend à revenir naturellement à l'horizontale.

Nous avons mis au point plusieurs stabilisateurs :

* Un premier, _mannequin_, retransmet uniquement les ordres du pilote sans chercher à stabiliser l'appareil : les données des capteurs sont ignorées.
* Un deuxième, stabilisateur _en vitesse_, régule la vitesse de rotation de l'axe. Les données du gyromètre, qui mesure cette vitesse, sont utilisées, celles de l'accéléromètre sont ignorées. Le pilote commande donc l'appareil en vitesse de rotation, c'est ce que l'on appelle le mode _acrobatique_ (à opposer au mode _stabilisé_ où le pilote commande l'inclinaison de l'axe).

Le pilote dirige le bicoptère à l'aide d'un manche depuis l'interface de commande (le manche est actuellement logiciel, mais un manche matériel, bien plus maniable, sera prochainement utilisé). Il peut également contrôler les gaz pour mettre plus ou moins de puissance dans les moteurs. Plus les moteurs déploieront de la puissance, plus l'appareil sera difficile à stabiliser (car des petites variations auront de plus grandes conséquences).

Le deuxième stabilisateur utilise un algorithme pour calculer la correction à apporter à la vitesse de rotation actuelle pour atteindre l'objectif fixé par le pilote. Il en existe plusieurs, mais c'est un des plus utilisés, le [<abbr title="Proportionnel-Intégral-Dérivé">PID</abbr>](https://fr.wikipedia.org/wiki/R%C3%A9gulateur_PID), que nous employerons. Je ne détaillerai pas son fonctionnement dans ce billet (mais peut-être dans un prochain !).

[![Bicoptère, avec sa nacelle](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/bicoptere-finished-thumbnail.jpg)](/img/blog/2015-premieres-experimentations-sur-le-bicoptere/bicoptere-finished.jpg)

Le stabilisateur _mannequin_ marche comme prévu : l'appareil reste assez stable grâce au poids de la batterie, et lorsque l'on bouge le manche d'un côté, une hélice tourne plus vite que l'autre et l'axe n'est plus horizontal.

Nous n'avons pas eu la même chance avec le stabilisateur _en vitesse_ : une petite perturbation de l'équilibre fait sur-réagir le stabilisateur et fait tourner une hélice beaucoup plus vite que l'autre, ce qui crée une perturbation plus grande, etc... Le stystème s'affole rapidement et devient instable en l'espace de quelques secondes. Il oscille de plus en plus et fait des tours complets de plus en plus violents, jusqu'à ce que les hélices ne supportant plus les variations brusques de vitesse volent à travers la pièce !

Nous avons essayé de changer certains paramètres du stabilisateur, mais les résultats restent comparables.

Nous allons donc revoir notre système de stabilisation, tester d'autres solutions, on vous tient au courant ! ;-)
