
# Use the official PHP image as the base image
FROM php:8.1-apache

# Copy the application files into the container
COPY . /var/www/html

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev

# Install additional PHP extensions using docker-php-ext-install
RUN docker-php-ext-install \
    mbstring \
    intl \
    zip

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy Laravel application
# Commenting out the line to copy the application files since it has already been copied above
# COPY . /var/www/html

# Set working directory
# Commenting out the second WORKDIR line since it has already been set above
# WORKDIR /var/www/html

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies using composer
RUN composer install

# Change ownership of our application files
RUN chown -R www-data:www-data /var/www/html

# Install mbstring extension again since it might not have been installed in previous steps
RUN docker-php-ext-install mbstring

# Copy Laravel environment file
COPY .env.example .env

# Generate Laravel application key
RUN php artisan key:generate

# Expose port 80
EXPOSE 80

# Adjust Apache configurations by copying the custom config file
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
