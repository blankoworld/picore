# picore

Outil qui parcourt la liste des pull request de api.github.com/repos/OWNER/PROJECT/pulls pour créer un fichier de configuration [Genèse](https://github.com/blankoworld/genese).

TODO: Format du fichier à mettre ici.

Le fichier de destination aura l'extension suivante : **.PR.blk

# Compilation

`make`

# Utilisation

`./picore`

Il est possible de changer le paramétrage du programme par les variables d'environnement suivantes : 

  * **OWNER**: nom de l'organisation ou du propriétaire qui détient la liste des pull request. Par défaut : **blankoworld.
  * **PROJECT**: nom du projet dans lequel on va trouver la liste des pull request. Par défaut : **dofus-almanax.
  * **DEST**: dossier de destination des fichiers de configuration. Par défaut **le dossier courant**.

Par exemple pour récupérer la liste des pull request de *github.com/blankoworld/dofus-almanax : 

`OWNER="blankoworld" PROJECT="dofus-almanax" ./picore`

# Développement

`crystal run src/picore.cr`

# Déploiement

On commence par faire un fichier .tar.xz :

`make extract`

On envoie le fichier résultant sur un serveur distant (si besoin).

On extraie l'archive.

Ensuite on copie les fichiers **picore.service** et **picore.timer** (contenus dans le dossier *service*) dans **/etc/systemd/system/**.

On copie le binaire **picore** dans un dossier, par exemple **/srv/picore** et on adapte les chemins vers la commande dans le fichier **/etc/systemd/system/picore.service**, par exemple : 

```
WorkingDirectory=/srv/picore
```

Adaptez tous les chemins adéquats.

Ensuite on lance les commandes suivantes : 

```
sudo systemctl daemon-reload
sudo systemctl enable picore.timer
sudo systemctl start picore.timer
# premier lancement du service (pour vérifier aussi)
sudo systemctl start picore.service
```

# Licence

Ce logiciel est concédé sous [licence EUPL, version 1.2 uniquement](http://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12).

# Contributeurs

- [Olivier DOSSMANN](https://github.com/blankoworld) - créateur et mainteneur

# Contact

Le projet est disponible sur [la page Github du projet picore](https://github.com/blankoworld/picore).
