FROM php:7.1-fpm-alpine

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

RUN docker-php-ext-enable \
xdebug
