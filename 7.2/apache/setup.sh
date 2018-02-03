#!/usr/bin/env bash
set -e

if [ ! "$(getent group ${UNIX_GROUP})" ]; then
    echo "Create group ${UNIX_GROUP}"
    if [ "$(which apk)" ]; then
        addgroup -g "${UNIX_GID}" "${UNIX_GROUP}"
    else
        groupadd --gid "${UNIX_GID}" "${UNIX_GROUP}"
    fi

    sed --in-place --expression="s/APACHE_RUN_GROUP:=www-data/APACHE_RUN_GROUP:=${UNIX_GROUP}/g" /etc/apache2/envvars
fi

if [ ! "$(getent passwd "${UNIX_USERNAME}")" ]; then
    echo "Create user ${UNIX_USERNAME}"
    if [ "$(which apk)" ]; then
        adduser -D -h /home/developer -u "${UNIX_UID}" "${UNIX_USERNAME}" -G "${UNIX_GROUP}"
    else
        useradd --home /home/developer --uid "${UNIX_UID}" --gid "${UNIX_GID}" "${UNIX_USERNAME}"
    fi

    sed --in-place --expression="s/APACHE_RUN_USER:=www-data/APACHE_RUN_USER:=${UNIX_USERNAME}/g" /etc/apache2/envvars
fi
