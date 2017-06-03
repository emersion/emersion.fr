+++
date = "2015-02-18T00:00:00+02:00"
title = "Hello World!"
lang = "fr"
+++

Bonjour à tous ! Ceci est mon premier article de blog. À cette occasion, je vais vous présenter mon petit projet de [TIPE](https://fr.wikipedia.org/wiki/Travail_d%27initiative_personnelle_encadr%C3%A9).

![Schéma (très) approximatif et artistique](/img/blog/2015-hello-world/quadcopter-ugly.png)
<p class="text-center">_Vue d'artiste sans prétention._</p>

J'ai eu l'idée de fabriquer un **quadcopter**, c'est-à-dire un helicoptère à quatre hélices (vous pouvez en contempler une _représentation artistique_ juste au-dessus). Dans un premier temps, les autres élèves de ma classe et mes professeurs étaient plutôt sceptiques, mais finalement certains ont adhéré à l'idée et le projet a pu voir le jour.

L'idée est donc de construire un quadcopter en partant de zéro : utiliser une plateforme déjà construite n'aurait pas d'intérêt dans notre cas. Les défis à relever sont entre autres :

* Le calcul des caractéristiques des composants, de façon à ce que l'engin puisse s'envoler
* La stabilisation de l'appareil en vol
* La commande à distance de la trajectoire
* La gestion de l'imprévu (liaison avec la télécommande perdue, batteries faibles, avarie matérielle, ~~grève du personnel de nettoyage des hélices~~...)

Je serais de plus assez intéressé par la réalisation d'une plateforme de haut niveau qui pourrait supporter plein de trucs cools comme une clef Wifi, un serveur Web, une caméra, etc...

J'ai donc imaginé, en tant que néophyte dans le milieu, une architecture provisoire :

![Schéma (un peu moins) approximatif](/img/blog/2015-hello-world/quadcopter-draft.png)
<p class="text-center">_Une représentation en fouillis de la compisition du quadcopter._</p>

Le tout est composé :

* D'un Ardiuno ou d'une AVR pour minimiser les temps de latence pour les décisions qui doivent être prises en temps réel comme la stabilisation
* D'un Raspberry Pi pour l'aspect haut niveau qui sera capable d'éxécuter les tâches plus lentes et plus évoluées comme la réception des commandes par Wifi, l'itinéraire à suivre, l'imagerie, éventuellement d'autres capteurs comme un GPS
* De gyroscopes et d'accéléromètres pour connaître l'orientation et la vitesse actuelle de l'appareil (c'est une sorte de niveau à bulle du XXIe siècle)
* De moteurs reliés à des pales, pour un rôle tout à fait secondaire
* Des batteries pour le Raspberry Pi et les moteurs
* D'une clef Wifi qui permettra de créer un réseau pour que des contrôleurs puissent s'y connecter (ordinateur portable, ordiphone...) et piloter l'OVNI via une petite interface Web (vive les Websockets !). Il serait également possible de rajouter une antenne radio pour une plus grande portée.

C'est un premier jet, il sera forcément amené à être amélioré et corrigé voire remplacé par la suite.

Pour la suite, la priorité va être la détermination des caractéristiques des composants du quadcopter. Je vais également faire quelques tests, notamment concernant l'utilisation d'un gyroscope/accéléromètre et d'une Ardiuno avec le Raspberry Pi.
