# Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /home/developer/.composer
ENV PATH "${COMPOSER_HOME}/vendor/bin:${PATH}"
RUN mkdir -p ${COMPOSER_HOME}
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer global require --prefer-dist --no-progress --no-interaction \
hirak/prestissimo \
pyrech/composer-changelogs \
bamarni/composer-bin-plugin \
sllh/composer-versions-check \
phpstan/phpstan-shim \
squizlabs/php_codesniffer \
dealerdirect/phpcodesniffer-composer-installer \
object-calisthenics/phpcs-calisthenics-rules:^3.4 \
wimg/php-compatibility \
nexylan/coding-standard:^0.0.2 \
&& composer clear-cache

# PHAR binaries
ADD https://phar.io/releases/phive.phar /usr/local/bin/phive
ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpunit-6.phar /usr/local/bin/phpunit-6
ADD https://phar.phpunit.de/phpunit-5.phar /usr/local/bin/phpunit-5
ADD http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer
ADD http://get.sensiolabs.org/php-cs-fixer-v1.13.1.phar /usr/local/bin/php-cs-fixer-1
ADD https://github.com/phpmd/phpmd/releases/download/2.7.0/phpmd.phar /usr/local/bin/phpmd
RUN ln -s /home/developer/.composer/vendor/phpstan/phpstan-shim/phpstan.phar /usr/local/bin/phpstan

# Make all binaries executable
RUN chmod 755 /usr/local/bin/*

RUN phive install --global \
    --trust-gpg-keys D2CCAC42F6295E7D \
    composer-require-checker

# Ruby gem (bundler and tools)
RUN gem install \
bundler

# Python packages (tools)
RUN pip install \
yamllint

ADD home/.bashrc /home/developer/
