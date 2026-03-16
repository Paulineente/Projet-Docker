#!/bin/bash

echo "Initialisation du projet Laravel..."

# Si le fichier .env n'existe pas encore, on en crée un à partir du modèle
if [ ! -f /var/www/html/.env ]; then
    cp /var/www/html/.env.example /var/www/html/.env
    echo "Fichier .env créé"
fi

# Installation des dépendances PHP via Composer
echo "Installation des dépendances Composer..."
composer install --no-interaction --prefer-dist --ignore-platform-reqs

# Installation des dépendances front (npm)
echo "Installation des dépendances NPM..."
npm install

# Compilation des assets (CSS/JS)
echo "Compilation des assets..."
npm run build

# Génération de la clé d'application si elle n'existe pas encore
if ! grep -q "APP_KEY=base64" /var/www/html/.env; then
    echo "Génération de la clé APP_KEY..."
    php artisan key:generate
fi

# Attente que MySQL soit disponible avant de lancer les migrations
echo "En attente de MySQL..."
until php -r "try { new PDO('mysql:host=mysql;port=3306;dbname=laravel', 'laravel', 'secret'); } catch (Exception \$e) { exit(1); }"; do
    echo "MySQL n'est pas encore prêt, nouvelle tentative..."
    sleep 2
done
echo "MySQL est prêt"

# Réinitialisation de la base + exécution des seeds
echo "Lancement des migrations et des seeds..."
php artisan migrate:fresh --seed

echo "Le projet Laravel est prêt à être utilisé !"

# Lancement de PHP-FPM (processus principal du conteneur)
exec php-fpm
