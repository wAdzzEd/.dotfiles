		----------------
		| INSTALLATION |
		----------------

I - Installation des prérequis.

Prérequis :
- git
- stow
- curl
- flameshot
- nala
- fontconfig
- kitty

Pour installer les prérequis, tapper les commandes :

	sudo apt update && sudo apt upgrade -y
	sudo apt-get install -y git stow curl flameshot nala fontconfig kitty

Pour installer starship, tapper la commande :

	curl -sS https://starship.rs/install.sh | sh

II - Déploiments de l'environnements :

Clonage du repo :

	cd ~
	git clone git@github.com:wAdzzEd/.dotfiles.git ~/.dotfiles

Déploiments des dotfiles :

	cd .dotfiles
	stow .

Rafraîchissement du cache :

	fc-cache -fv

Recharger le terminal :

	source ~/.bashrc

Installation terminé !


			-----------
			| UPDATES |
			-----------
I - Update du repo.

Après avoir modifier les fichiers dotfiles :

	cd ~/.dotfiles
	stow .
	git add .
	git commit -m "chemin/vers/fichier/modifier : changement apporté au fichier"
	git push

II - Update de l'environnement.

Commandes à tapper pour mettre à jour l'environnement :

	cd ~/.dotfiles
	git pull
	stow .
	source ~./bashrc
