+++
date = "2015-03-29T00:00:00+02:00"
title = "Shopping et propeller attack"
slug = "shopping-et-propeller-attack"
lang = "fr"
tags = ["quadcopter", "javascript"]
+++

Il y a un peu de nouveau concernant le projet de quadcopter que j'ai présenté dans [mon premier article](/blog/2015/hello-world/). Nous avons finalement eu le temps d'acheter le matériel nécessaire dans une boutique d'aéromodélisme, et j'ai pu dans un second temps commander une hélice via le Raspberrypi.

## Shopping

Après avoir [comparé](https://github.com/flying-mole/docs/blob/master/specs/hardware.md#comparaison-avec-dautres-projets-existants) les composants utilisés sur quelques projets de quadcopter similaires, nous avons choisi dans les grandes lignes les caractéristiques de ce qu'on allait acheter. Nous sommes allés dans [une petite boutique de modélisme](http://www.batmodelisme.com/) à Athis-Mons où nous avons pu être conseillés par le vendeur. Nous sommes donc sortis du magasin avec :

* 4 moteurs _brushless_ 1150Kv : il nous a fallu choisir entre moteurs peu consommateurs mais peu puissants et moteurs robustes mais peu économiques. Le prix a également été un facteur déterminant.
* 4 _Electronic Speed Control_ (ESC) ou contrôleurs de vitesse : ils servent à alimenter et moduler la vitesse des moteurs. Les moteurs _brushless_ n'étant pas des moteurs à courant continu, il ne suffit pas de les alimenter pour qu'ils fonctionnent. Il faut leur fournir un courant alternatif et la fréquence détermine la vitesse de rotation.
* 4 hélices à deux pales, c'est du bas de gamme parce que ça se casse facilement. Nous avons pris des hélices assez grandes (10x4.5 in) pour avoir plus de stabilité (d'après le vendeur, les hélices plus petites sont également assez stables car elles tournent plus vite et donc l'effet gyroscopique est plus important).
* Une batterie LiPo : il a là encore fallu faire un choix entre prix, poids et autonomie. Une batterie 3300Mah nous a finalement convaincus, tout est une histoire de juste milieu.
* Enfin, un chargeur pour la batterie et des baguettes de bois pour la structure (mais ça, c'est pour plus tard).

Voici une vue d'ensemble de nos achats (chaque composant n'est présent qu'une seule fois) :

[![Composants](/img/blog/2015-shopping-et-propeller-attack/parts-thumbnail.jpg)](/img/blog/2015-shopping-et-propeller-attack/parts.jpg)

Ce sont les moteurs et les contrôleurs qui nous ont coûté le plus cher (vous pouvez consulter la [liste des pièces utilisées](https://github.com/flying-mole/docs/blob/master/spending.csv) pour voir le prix des autres articles).

## _Propeller attack_

Le matériel étant acheté, il ne nous reste plus qu'à réaliser ! J'en ai profité pour essayer au plus vite de contrôler les moteurs _brushless_ depuis le Raspberry Pi.

### Montage du circuit

Les branchements sont assez simples : les deux bornes d'alimentation du contrôleur (rouges et noir) vont vers la batterie, trois connecteurs sont prévus pour être reliés au moteur (deux pour l'alimentation, un pour un retour d'information) et les trois derniers (orange, rouge, marron) sont connectés au Raspberry Pi.

Ici, on n'utilisera pas le connecteur rouge qui sort du 5V : on alimente le Raspberry Pi avec une prise secteur ordinaire. Par contre, lorsqu'on voudra faire voler le tout, on s'en servira avec joie. Le connecteur marron doit être relié à la masse et le connecteur orange à un GPIO.

[![Schéma des liaisons](/img/blog/2015-shopping-et-propeller-attack/raspi-esc-brushless-thumbnail.png)](/img/blog/2015-shopping-et-propeller-attack/raspi-esc-brushless.png)

### Commande du moteur

Le circuit réalisé, il nous faut maintenant nous occuper de la partie logicielle. Nous pouvons contrôler l'ESC en envoyant des impulsions via le GPIO, c'est la durée des impulsions qui déterminera la vitesse du moteur (cette technique est appelée [PWM](https://fr.wikipedia.org/wiki/Modulation_de_largeur_d%27impulsion)).

Il existe plusieurs librairies qui sont capables d'envoyer des impulsions de ce type. [ServoBlaster](https://github.com/richardghirst/PiBits/tree/master/ServoBlaster) m'a semblé la librarie la plus adaptée. L'installation est simple :

```bash
git clone https://github.com/richardghirst/PiBits.git
cd PiBits/ServoBlaster/user
nano init-script
# Supprimer la valeur --idle-timeout=2000 des options par défaut
make
sudo make install
```

Il existe maintenant un périphérique `/dev/servoblaster` prêt à recevoir nos ordres. Il est dès maintenant possible de démarrer le moteur :

```bash
echo 0=110 > /dev/servoblaster
```

En envoyant `0=110` au périphérique, on lui demande d'envoyer des impulsions de 1100 microsecondes au moteur numéro 0, ce qui correspond au GPIO 4 (la table de correspondance est dans [la doc](https://github.com/richardghirst/PiBits/tree/master/ServoBlaster)). Pour les ESC dont nous disposons, on peut aller de 100 à 185, à 100 le moteur est à l'arrêt et à 185 il est à pleine vitesse.

J'ai créé un petit module appelé [node-servoblaster](https://github.com/emersion/node-servoblaster) pour envoyer des ordres à ServoBlaster depuis Node.js. Voici comment l'utiliser :

```js
var servoblaster = require('servoblaster'); // Import du module

var stream = servoblaster.createWriteStream(0); // On ouvre un flux vers ServoBlaster pour le moteur numéro 0
stream.write(110); // On envoie l'ordre
stream.end(); // On ferme le flux
```

### Résultats

[![Montage final](/img/blog/2015-shopping-et-propeller-attack/prop-thumbnail.jpg)](/img/blog/2015-shopping-et-propeller-attack/prop.jpg)

À vide, je n'ai pas eu peur de pousser les gaz à fond, mais quand l'hélice est montée, c'est une autre histoire. La plaquette de bois à laquelle le moteur est attaché commence à décoller vers 125 - 135, et quand je suis monté à 150, l'hélice s'est détachée de l'axe et a volé à travers la pièce (d'où le titre de cet article !). Je ne suis pas un pro de modélisme, il faudra donc expérimenter plusieurs manières de fixer l'hélice.

Comme d'hab, voici une petite vidéo du résultat (ne pas m'en vouloir, c'est fait à l'arrache) :

<iframe width="420" height="315" src="https://www.youtube.com/embed/8W6jQgAOdHE" frameborder="0" allowfullscreen></iframe>
