# Composer
ENV COMPOSER_HOME /home/developer/.composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir -p ${COMPOSER_HOME}
RUN composer global require --prefer-dist --no-progress --no-interaction \
hirak/prestissimo \
pyrech/composer-changelogs \
sllh/composer-versions-check \
&& composer clear-cache

# PHPUnit
RUN wget --quiet -O /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/local/bin/phpunit
RUN wget --quiet -O /usr/local/bin/phpunit-old https://phar.phpunit.de/phpunit-old.phar && chmod +x /usr/local/bin/phpunit-old

# PHP-CS-Fixer
RUN wget --quiet -O /usr/local/bin/php-cs-fixer http://get.sensiolabs.org/php-cs-fixer.phar && chmod +x /usr/local/bin/php-cs-fixer
RUN wget --quiet -O /usr/local/bin/php-cs-fixer-1 http://get.sensiolabs.org/php-cs-fixer-v1.13.1.phar && chmod +x /usr/local/bin/php-cs-fixer-1

# Ruby gem (bundler and tools)
RUN gem install \
bundler \
yaml-lint

ADD home/.bashrc /home/developer/
