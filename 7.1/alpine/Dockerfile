FROM php:7.1-alpine

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

ENV BUILD_DEPS \
    autoconf \
    gcc \
    make \
    wget \
    libc-dev \
    zlib-dev \
    icu-dev \
    libpng-dev \
    libmcrypt-dev \
    libxml2-dev \
    jpeg-dev \
    libxpm-dev \
    freetype-dev \
    krb5-dev \
    openssl-dev

# Needed persistent dependencies
RUN apk add --no-cache \
    ruby \
    ruby-rdoc \
    ruby-irb \
    nodejs \
    libpng \
    libjpeg-turbo \
    libxpm \
    libmcrypt-dev \
    krb5 \
    freetype \
    icu-dev \
    imap-dev

# Tools
RUN apk add --no-cache ${TOOLS_PACKAGES}

# Extensions install and configure
RUN set -xe \
    && apk add --no-cache --virtual .build-deps ${BUILD_DEPS} \
    && pecl install --force ${PECL_PACKAGES} \
    && configure \
    && apk del .phpize-deps-configure \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) ${PHP_EXTENSIONS} \
    && apk del .build-deps

# Yarn setup
ADD https://yarnpkg.com/latest.tar.gz /opt/yarn.tar.gz
RUN cd /opt \
    && mkdir yarn \
    && tar xzf yarn.tar.gz -C yarn --strip-components 1 \
    && cd /usr/local/bin \
    && ln -s /opt/yarn/bin/yarn

# Composer
ENV COMPOSER_HOME /home/developer/.composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir -p ${COMPOSER_HOME}
RUN composer global require --prefer-dist --no-progress --no-interaction \
hirak/prestissimo \
pyrech/composer-changelogs \
sllh/composer-versions-check \
&& composer clear-cache

# PHAR binaries
ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpunit-old.phar /usr/local/bin/phpunit-old
ADD http://get.sensiolabs.org/php-cs-fixer.phar /usr/local/bin/php-cs-fixer
ADD http://get.sensiolabs.org/php-cs-fixer-v1.13.1.phar /usr/local/bin/php-cs-fixer-1

# Make all binaries executable
RUN chmod 755 /usr/local/bin/*

# Ruby gem (bundler and tools)
RUN gem install \
bundler \
yaml-lint

ADD home/.bashrc /home/developer/
