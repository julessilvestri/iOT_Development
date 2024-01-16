# Exercice

## Les Targets :
Les targets dans Xcode représentent les différentes versions ou configurations de l'application que l'on créer à partir du même code source. Chaque cible (target) peut avoir ses propres paramètres de compilation, de build, et de déploiement. 
## Les Fichiers :
Les fichiers dans Xcode se réfèrent à toutes les ressources et le code source qui composent le projet. Cela inclut les fichiers source (.swift pour le langage Swift, .m pour Objective-C), les fichiers de configuration, les images, etc...
## Les Assets :
Les "assets" regroupent les types de ressources graphiques dans l'application, tels que les images, les icônes, les fichiers audio, etc... 
## Ouvrir le Storyboard :
Le storyboard est une représentation visuelle de l'interface utilisateur de l'application.
## Ouvrir un Simulateur :
Les simulateurs dans Xcode permettent d'émuler différents appareils iOS sur l'ordinateur, vous permettant de tester votre application dans un environnement proche de celui d'un véritable appareil iOS.
## Lancer une Application sur le Simulateur :
Une fois que l'application est développée, on peut la lancer sur le simulateur pour effectuer des tests. Cela permet de vérifier le fonctionnement de l'application avant de la déployer sur des appareils réels.

# Exercice

- La commande `Command` + `R` sert build (run) l'application
- La commande `Command` + `Shift` + `O` sert à rechercher et ouvrir un fichier
- La commande `Ctrl` + `i` sert à reformater le code
- La commande `Command` + `/` sert à commenter le code

# Exercice
En programmation, une propriété statique est une variable qui est associée à la classe plutôt qu'à une instance spécifique de cette classe. Cela signifie qu'une seule copie de la variable existe, indépendamment du nombre d'instances de la classe créées.

Question :  Expliquer pourquoi dequeueReusableCell est important pour les performances de l’application.

Car elle réutilise la cellule créer précedement et permet de ne pas gérer les celulles situé hors de l'écran, c'est une question de performance.
