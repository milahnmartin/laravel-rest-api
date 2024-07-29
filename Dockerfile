# Use the official PHP image as base
FROM php:8.2-fpm

# Set working directory inside the container
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# Install Composer (PHP package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy composer.json and composer.lock to the working directory
COPY composer.json composer.lock ./

# Install application dependencies
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application code
COPY . .

# Generate the autoloader
RUN composer dump-autoload --no-scripts --no-dev --optimize

# Expose port 9000 to communicate with the PHP-FPM process
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]
