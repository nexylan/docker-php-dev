#!/usr/bin/env bash
set -e

if [ ! "$(getent group ${UNIX_GROUP})" ]; then
    echo "Create group ${UNIX_GROUP}"
    addgroup -g "${UNIX_GID}" "${UNIX_GROUP}"

    sed --in-place --expression="s/APACHE_RUN_GROUP:=www-data/APACHE_RUN_GROUP:=${UNIX_GROUP}/g" /etc/apache2/envvars
fi

if [ ! "$(getent passwd "${UNIX_USERNAME}")" ]; then
    echo "Create user ${UNIX_USERNAME}"
    adduser -u "${UNIX_UID}" "${UNIX_USERNAME}"
    adduser "${UNIX_USERNAME}" "${UNIX_GROUP}"

    sed --in-place --expression="s/APACHE_RUN_USER:=www-data/APACHE_RUN_USER:=${UNIX_USERNAME}/g" /etc/apache2/envvars
fi
