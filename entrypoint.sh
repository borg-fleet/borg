#!/bin/bash
set -e

if [ -n "${SSHD_CONF}" ]; then echo "${SSHD_CONF}" > /etc/ssh/sshd_config; fi
ssh-keygen -A

exec "$@"