#!/usr/bin/env bash
set -e

if [ ! "$(getent group ${UNIX_GROUP})" ]; then
    echo "Create group ${UNIX_GROUP}"
    addgroup -g "${UNIX_GID}" "${UNIX_GROUP}"

    sed --in-place --expression="s/group = www-data/group = ${UNIX_GROUP}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! "$(getent passwd "${UNIX_USERNAME}")" ]; then
    echo "Create user ${UNIX_USERNAME}"
    adduser -u "${UNIX_UID}" "${UNIX_USERNAME}"
    adduser "${UNIX_USERNAME}" "${UNIX_GROUP}"

    sed --in-place --expression="s/user = www-data/user = ${UNIX_USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf
fi
