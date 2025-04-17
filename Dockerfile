FROM php:8.3-apache

RUN apt-get update && apt-get install -y libicu-dev gettext && \
    docker-php-ext-install intl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    a2enmod rewrite && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY . ./
COPY ports.conf.template /etc/apache2/ports.conf.template

RUN mv entrypoint.sh /usr/local/bin/whois-domain-lookup-entrypoint && \
    chmod +x /usr/local/bin/whois-domain-lookup-entrypoint

ENTRYPOINT ["whois-domain-lookup-entrypoint"]

CMD ["/bin/sh", "-c", "envsubst < /etc/apache2/ports.conf.template > /etc/apache2/ports.conf && apache2-foreground"]
