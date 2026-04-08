FROM wordpress:php8.3-fpm-alpine

RUN apk add --no-cache $PHPIZE_DEPS linux-headers \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install opcache \
    && apk del $PHPIZE_DEPS

COPY ./src /var/www/html

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD ["php-fpm", "-t"]