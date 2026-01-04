# Gunakan PHP 8.2 dengan Apache (paling gampang buat Laravel)
FROM php:8.2-apache

# Install ekstensi yang dibutuhkan Laravel (Zip, Git, MySQL driver)
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql zip

# Aktifkan mod_rewrite (supaya routing Laravel jalan/nggak 404)
RUN a2enmod rewrite

# Ubah setting Apache supaya menunjuk ke folder /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# Copy semua kodingan kamu ke dalam Docker
COPY . /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Jalankan perintah install library (vendor)
RUN composer install --no-dev --optimize-autoloader

# Atur hak akses folder storage supaya bisa write data
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache