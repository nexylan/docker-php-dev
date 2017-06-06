#!/usr/bin/env bash
set -e

if [ ! "$(getent group ${UNIX_GROUP})" ]; then
    echo "Create group ${UNIX_GROUP}"
    groupadd --gid "${UNIX_GID}" "${UNIX_GROUP}"

    sed --in-place --expression="s/group = www-data/group = ${UNIX_GROUP}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! "$(getent passwd "${UNIX_USERNAME}")" ]; then
    echo "Create user ${UNIX_USERNAME}"
    useradd --uid "${UNIX_UID}" --gid "${UNIX_GID}" "${UNIX_USERNAME}"

    sed --in-place --expression="s/user = www-data/user = ${UNIX_USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf
fi
