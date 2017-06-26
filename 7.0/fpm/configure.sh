#!/usr/bin/env bash
set -e

docker-php-ext-configure gd \
    --with-freetype-dir=/usr/ \
    --with-jpeg-dir=/usr/ \
    --with-xpm-dir=/usr/ \
    --with-vpx-dir=/usr/

docker-php-ext-configure imap \
    --with-kerberos \
    --with-imap-ssl
