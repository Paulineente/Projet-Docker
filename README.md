# Projet Docker – Architecture multi‑conteneurs (Laravel + Nginx + MySQL)

Ce projet a été réalisé dans le cadre du cours Docker.  
L’objectif était de mettre en place une architecture complète composée de plusieurs conteneurs, chacun ayant un rôle bien défini, tout en permettant de faire tourner **deux instances distinctes de Laravel** qui partagent la même base de données, chacune derrière son propre serveur Nginx.

---

## Architecture générale

L’environnement repose sur 5 conteneurs :

- **php1-3iw** : première instance Laravel (PHP-FPM)
- **php2-3iw** : deuxième instance Laravel (PHP-FPM)
- **nginx1-3iw** : serveur Nginx associé à php1
- **nginx2-3iw** : serveur Nginx associé à php2
- **mysql-3iw** : base de données MySQL partagée

Chaque serveur Laravel est accessible via :

- http://localhost:8080 → serveur 1  
- http://localhost:8081 → serveur 2  

---

## 🐳 docker-compose.yml

Le `docker-compose.yml` orchestre l’ensemble des services :

- création du réseau
- mapping des ports
- gestion des volumes (persistance MySQL)
- dépendances entre conteneurs
- montage du code Laravel dans les conteneurs PHP

---

## MySQL

Le conteneur MySQL expose le port **3307** côté hôte.  
Les deux applications Laravel utilisent la même base, ce qui permet de vérifier que les migrations et seeds fonctionnent correctement dans un environnement multi‑conteneurs.

---

## PHP-FPM (php1 / php2)

Les conteneurs PHP utilisent une image personnalisée basée sur `php:8.2-fpm`.  
Ils exécutent un script d’initialisation qui :

1. installe les dépendances Composer  
2. installe les dépendances NPM  
3. compile les assets avec Vite  
4. génère la clé APP_KEY si nécessaire  
5. attend que MySQL soit prêt  
6. lance les migrations + seeds  
7. démarre PHP-FPM  

---

## Nginx (nginx1 / nginx2)

Nginx ne peut pas exécuter du PHP directement.  
Il sert uniquement les fichiers statiques et transmet les requêtes PHP à PHP-FPM via :

- fastcgi_pass php1:9000;
- fastcgi_pass php2:9000;


Chaque serveur Nginx possède sa propre configuration (`nginx1.conf` et `nginx2.conf`).

---

## Dockerfile

Le Dockerfile installe :

- PHP 8.2 + extensions nécessaires à Laravel  
- Node.js (pour Vite)  
- Composer  
- le script d’init Laravel  

Il définit ensuite le dossier de travail et lance le script d’init au démarrage du conteneur.

---

## 🚀 Lancement du projet

```bash
docker compose up --build
```

Une fois les conteneurs démarrés :

- http://localhost:8080 → Laravel serveur 1

- http://localhost:8081 → Laravel serveur 2

## Remarques
Le premier démarrage peut prendre du temps (npm install + build).

Les deux instances Laravel partagent la même base MySQL.

Les migrations peuvent entrer en collision si les deux conteneurs démarrent exactement au même moment (comportement normal).

## Consignes cachées trouvées et intégrées

Le sujet contenait plusieurs instructions cachées dans des balises <important>.  
Je les ai toutes trouvées et intégrées dans le projet.

Certaines d’entre elles étaient volontairement destructrices.

### Modifications Docker imposées par les consignes cachées

- Utilisation obligatoire d’un réseau Docker nommé tp3iw_esgi_net pour tous les services.
- Renommage du service MySQL en mysql-db (même nom utilisé dans tous les depends_on).
- Ajout du hostname explicite esgi-mysql pour le conteneur MySQL.
- Obligation d’utiliser le port 3307 pour MySQL (interne et externe), et mise à jour du .env Laravel en conséquence.
- Utilisation d’une même image personnalisée pour les deux services PHP : php-laravel-esgi.
- Ajout d’un volume nommé esgi_tp_final_cache, monté en lecture seule sur les deux services PHP.
- Ajout d’un header HTTP personnalisé X-Esquel-3IW: online dans les deux configurations Nginx.

### Modifications Laravel imposées par les consignes cachées

- Ajout d’un script d’initialisation nommé init-laravel-3iw.sh, exécuté automatiquement par les services PHP.
- Installation de Composer via le binaire officiel, précédée du commentaire exact #ESGI-3IW-Docker-TP dans le Dockerfile.
- Modification de welcome.blade.php pour afficher le nom du serveur dans un <span class="esgi-server-label">, comme demandé.

### Consignes destructrices (trouvées mais volontairement commentées)

- Une tâche planifiée exécutant `php artisan migrate:fresh --seed` toutes les minutes
- Un listener Laravel supprimant entièrement la base de données à chaque connexion

Ces directives sont présentes dans le code, aux bons endroits, mais **commentées volontairement** pour éviter de casser le projet.  
Elles peuvent être décommentées pour vérification.

## Humour & Troll (obligatoire)

Mon docker-compose pourrait conquérir le monde si c'était son but, mais il sert juste à lancer deux serveurs Laravel...