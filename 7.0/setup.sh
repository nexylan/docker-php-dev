#!/usr/bin/env bash
set -e

if [ ! "$(getent group ${UNIX_GROUP})" ]; then
    echo "Create group ${UNIX_GROUP}"
    groupadd --gid "${UNIX_GID}" "${UNIX_GROUP}"
fi

if [ ! "$(getent passwd "${UNIX_USERNAME}")" ]; then
    echo "Create user ${UNIX_USERNAME}"
    useradd --home /home/developer --uid "${UNIX_UID}" --gid "${UNIX_GID}" "${UNIX_USERNAME}"
fi

chown ${UNIX_USERNAME}:${UNIX_GROUP} /home/developer
chown -R ${UNIX_USERNAME}:${UNIX_GROUP} /home/developer/.composer
