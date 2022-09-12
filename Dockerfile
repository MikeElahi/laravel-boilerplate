FROM php:8.1-rc-fpm-buster

USER root

WORKDIR /var/www

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential openssl nginx libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev zlib1g-dev libzip-dev gcc g++ make vim unzip curl git \
	&& apt-get install -y --no-install-recommends libgmp-dev \
	&& apt-get autoclean -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/pear/

COPY . /var/www

RUN chmod +rwx /var/www
RUN chmod -R 777 /var/www

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --working-dir="/var/www" --optimize-autoloader --no-dev --no-ansi

EXPOSE 8000

CMD php artisan serve --host=0.0.0.0
