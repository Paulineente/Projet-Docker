FROM php:8.2-fpm

# Installation des dépendances système nécessaires à Laravel
# (extensions PHP, outils de base, librairies pour images, zip, etc.)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    sqlite3 \
    libpq-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip

# Installation de Node.js (nécessaire pour compiler les assets Laravel)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Installation de Composer (gestionnaire de dépendances PHP)
# ESGI-3IW-Docker-TP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Dossier de travail du conteneur
WORKDIR /var/www/html

# Ajout du script d'initialisation Laravel dans le conteneur
COPY ./init-laravel-3iw.sh /usr/local/bin/init-laravel-3iw.sh
RUN chmod +x /usr/local/bin/init-laravel-3iw.sh

# Autorise PHP-FPM à récupérer les variables d'environnement du conteneur
RUN sed -i 's/^;clear_env = no/clear_env = no/' /usr/local/etc/php-fpm.d/www.conf

# Port utilisé par PHP-FPM
EXPOSE 9000

# Le conteneur démarre en exécutant le script d'init Laravel
ENTRYPOINT ["/usr/local/bin/init-laravel-3iw.sh"]