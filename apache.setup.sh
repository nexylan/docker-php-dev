#!/usr/bin/env bash
set -e

if [ ! "$(getent group ${UNIX_GROUP})" ]; then
    echo "Create group ${UNIX_GROUP}"
    groupadd --gid "${UNIX_GID}" "${UNIX_GROUP}"

    sed --in-place --expression="s/APACHE_RUN_GROUP:=www-data/APACHE_RUN_GROUP:=${UNIX_GROUP}/g" /etc/apache2/envvars
fi

if [ ! "$(getent passwd "${UNIX_USERNAME}")" ]; then
    echo "Create user ${UNIX_USERNAME}"
    useradd --uid "${UNIX_UID}" --gid "${UNIX_GID}" "${UNIX_USERNAME}"

    sed --in-place --expression="s/APACHE_RUN_USER:=www-data/APACHE_RUN_USER:=${UNIX_USERNAME}/g" /etc/apache2/envvars
fi
