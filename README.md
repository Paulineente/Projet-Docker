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
