FROM php:7.0-alpine

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
    py-pip \
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
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /home/developer/.composer
ENV PATH "${COMPOSER_HOME}/vendor/bin:${PATH}"
RUN mkdir -p ${COMPOSER_HOME}
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer global require --prefer-dist --no-progress --no-interaction \
hirak/prestissimo \
pyrech/composer-changelogs \
sllh/composer-versions-check \
phpstan/phpstan-shim \
squizlabs/php_codesniffer \
dealerdirect/phpcodesniffer-composer-installer \
doctrine/coding-standard \
escapestudios/symfony2-coding-standard \
object-calisthenics/phpcs-calisthenics-rules \
slevomat/coding-standard \
wimg/php-compatibility \
&& composer clear-cache

# PHAR binaries
ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpunit-old.phar /usr/local/bin/phpunit-old
ADD http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer
ADD http://get.sensiolabs.org/php-cs-fixer-v1.13.1.phar /usr/local/bin/php-cs-fixer-1
RUN ln -s /home/developer/.composer/vendor/phpstan/phpstan-shim/phpstan.phar /usr/local/bin/phpstan

# Make all binaries executable
RUN chmod 755 /usr/local/bin/*

# Ruby gem (bundler and tools)
RUN gem install \
bundler

# Python packages (tools)
RUN pip install \
yamllint

ADD home/.bashrc /home/developer/
