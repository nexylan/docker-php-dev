FROM php:7.0-fpm

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
mbstring

# GD configuration
RUN docker-php-ext-configure gd \
--with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
--with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
--with-xpm-dir=/usr/lib/x86_64-linux-gnu/ \
--with-vpx-dir=/usr/lib/x86_64-linux-gnu/

ADD setup.sh /usr/local/bin/setup
RUN chmod u+x /usr/local/bin/setup
