FROM php:7.1

# Common ENV definitions

ENV PECL_PACKAGES \
    xdebug

ENV PHP_EXTENSIONS \
    zip \
    pdo \
    pdo_mysql \
    intl \
    gd \
    pcntl \
    bcmath \
    shmop \
    mbstring \
    exif \
    mcrypt \
    imap \
    soap

ENV TOOLS_PACKAGES \
    bash \
    make \
    wget \
    curl \
    git \
    openssh-client \
    mysql-client

ADD configure.sh /usr/local/bin/configure
RUN chmod u+x /usr/local/bin/configure

ADD setup.sh /usr/local/bin/setup
RUN chmod u+x /usr/local/bin/setup

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
libmcrypt-dev \
libc-client-dev \
libkrb5-dev \
libxml2-dev \
libicu-dev \
&& rm --recursive --force /var/lib/apt/lists/*

# Special NodeJS apt setup (Use LTS version)
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
&& apt-get install nodejs \
&& rm --recursive --force /var/lib/apt/lists/*

# Special Yarn apt setup
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update \
&& apt-get install yarn \
&& rm --recursive --force /var/lib/apt/lists/*

# Extra languages needed for tools
RUN apt-get update && apt-get install --yes \
ruby \
ruby-dev \
&& rm --recursive --force /var/lib/apt/lists/*

# Tools
RUN apt-get update && apt-get install --yes ${TOOLS_PACKAGES} && rm --recursive --force /var/lib/apt/lists/*

# PECL extensions
RUN pecl install ${PECL_PACKAGES}

RUN configure

# Extensions
# https://github.com/docker-library/docs/blob/master/php/content.md#how-to-install-more-php-extensions
RUN docker-php-ext-install -j`nproc` ${PHP_EXTENSIONS}

# Composer
ENV COMPOSER_HOME /home/developer/.composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir -p ${COMPOSER_HOME}
RUN composer global require --prefer-dist --no-progress --no-interaction \
hirak/prestissimo \
pyrech/composer-changelogs \
sllh/composer-versions-check \
phpstan/phpstan-shim \
&& composer clear-cache

# PHAR binaries
ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpunit-old.phar /usr/local/bin/phpunit-old
ADD http://get.sensiolabs.org/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer
ADD http://get.sensiolabs.org/php-cs-fixer-v1.phar /usr/local/bin/php-cs-fixer-1
RUN ln -s /home/developer/.composer/vendor/phpstan/phpstan-shim/phpstan.phar /usr/local/bin/phpstan

# Make all binaries executable
RUN chmod 755 /usr/local/bin/*

# Ruby gem (bundler and tools)
RUN gem install \
bundler \
yaml-lint

ADD home/.bashrc /home/developer/
