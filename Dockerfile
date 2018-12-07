FROM php:7.2-apache

ENV APACHE_DOCUMENT_ROOT /var/www/html

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl

# Install PHP library
RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get -y update
RUN apt-get -y install imagemagick wget optipng supervisor cron

# Clear APT cache
RUN apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

# Install PHP composer
RUN curl -s http://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#ADD supervisord.conf /etc/supervisord.conf
ADD docker/sv-crond.conf /etc/supervisor/conf.d
ADD docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /

CMD ["/usr/local/bin/start.sh", "apache2-foreground"]
