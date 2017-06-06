RUN docker-php-ext-enable \
xdebug

RUN a2dissite 000-default

RUN a2enmod \
rewrite
