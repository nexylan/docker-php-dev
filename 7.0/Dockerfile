FROM php:7.0

# Needed libraries
RUN apt-get update && apt-get install --yes \
libssl-dev \
libicu-dev \
zlib1g-dev \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng12-dev \
libgif-dev \
libxpm-dev \
libvpx-dev \
libsqlite3-dev \
&& rm --recursive --force /var/lib/apt/lists/*

# Extra languages needed for tools
RUN apt-get update && apt-get install --yes \
ruby \
ruby-dev \
&& rm --recursive --force /var/lib/apt/lists/*

# Tools
RUN apt-get update && apt-get install --yes \
wget \
curl \
git \
npm \
mysql-client \
&& rm --recursive --force /var/lib/apt/lists/*

# PECL extensions
RUN pecl install \
xdebug \
&& docker-php-ext-enable \
xdebug

# Extensions
RUN docker-php-ext-install -j`nproc` \
zip \
pdo \
pdo_mysql \
intl \
gd \
pcntl \
bcmath \
shmop \
mbstring

# GD configuration
RUN docker-php-ext-configure gd \
--with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
--with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
--with-xpm-dir=/usr/lib/x86_64-linux-gnu/ \
--with-vpx-dir=/usr/lib/x86_64-linux-gnu/

# Composer
ENV COMPOSER_HOME /home/developer/.composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir -p ${COMPOSER_HOME}
RUN composer global require --no-update \
hirak/prestissimo \
pyrech/composer-changelogs \
sllh/composer-versions-check \
&& composer global install --prefer-dist --no-progress --no-interaction \
&& composer clear-cache

# PHPUnit
RUN wget --quiet -O /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/local/bin/phpunit
RUN wget --quiet -O /usr/local/bin/phpunit-old https://phar.phpunit.de/phpunit-old.phar && chmod +x /usr/local/bin/phpunit-old

# PHP-CS-Fixer
RUN wget --quiet -O /usr/local/bin/php-cs-fixer http://get.sensiolabs.org/php-cs-fixer-v2.0.0-alpha.phar && chmod +x /usr/local/bin/php-cs-fixer
RUN wget --quiet -O /usr/local/bin/php-cs-fixer-1 http://get.sensiolabs.org/php-cs-fixer.phar && chmod +x /usr/local/bin/php-cs-fixer-1

# NodeJS link trick
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Ruby gem (bundler and tools)
RUN gem install \
bundler \
yaml-lint

ADD setup.sh /usr/local/bin/setup
RUN chmod u+x /usr/local/bin/setup
