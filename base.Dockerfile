ARG version
ARG base
ARG variant=''

FROM php:${version}${variant}${base}

ADD configure.sh /usr/local/bin/configure
ADD setup.sh /usr/local/bin/setup
RUN chmod u+x /usr/local/bin/*

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
