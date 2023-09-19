
# Use the official PHP image as the base image
FROM php:8.1-apache

# Copy the application files into the container
COPY . /var/www/html

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary PHP extensions and dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip

# Install additional PHP extensions using docker-php-ext-install
RUN docker-php-ext-install \
    mbstring \
 intl

# Enable rewrite module
RUN a2enmod rewrite  # Fixed typo: changed "aenmod" to "a2enmod"

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies using composer
RUN composer install --no-dev --prefer-dist --no-scripts --no-progress --no-interaction

# Change ownership of our application files
RUN chown -R www-data:www-data /var/www/html  # Added ":" to specify group ownership

# Copy Laravel file
COPY .env.example .env

# Generate application key
RUN php artisan key:generate

# Expose port 80
EXPOSE 80

# Adjust Apache configurations by copying custom file
COPY apache-config /etc/apache2/sites-available/000-default.conf
