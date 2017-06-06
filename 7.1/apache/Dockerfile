FROM php:7.1-apache

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
mysql-client \
&& rm --recursive --force /var/lib/apt/lists/*

# PECL extensions
RUN pecl install \
xdebug

# GD configuration
RUN docker-php-ext-configure gd \
--with-freetype-dir=/usr/ \
--with-jpeg-dir=/usr/ \
--with-xpm-dir=/usr/ \
--with-vpx-dir=/usr/

# IMAP configuration
RUN docker-php-ext-configure imap \
--with-kerberos --with-imap-ssl

# Extensions
# https://github.com/docker-library/docs/blob/master/php/content.md#how-to-install-more-php-extensions
RUN docker-php-ext-install -j`nproc` \
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

RUN docker-php-ext-enable \
xdebug

RUN a2dissite 000-default

RUN a2enmod \
rewrite

ADD setup.sh /usr/local/bin/setup
RUN chmod u+x /usr/local/bin/setup
