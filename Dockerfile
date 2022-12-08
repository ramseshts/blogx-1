FROM php:7.4.33

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

RUN curl -sS https://getcomposer.org/installer​ | php -- \
     --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
ENV LARAVEL .env
COPY . /app
COPY ${LARAVEL} /app
RUN composer install --prefer-dist

CMD php artisan serve --host=0.0.0.0 --port=9000 
EXPOSE 9000