#!/usr/bin/env bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "${SCRIPT_DIR}"

echo "Starting test setup..."
docker-compose up -d


echo "Wait for LDAP to become online..."
SECONDS=0
until exec 3<>/dev/tcp/localhost/389
do
  if (( SECONDS > 60 ))
  then
     echo "Giving up..."
     exit 1
  fi
  echo "LDAP is not up yet. Waiting..."
  sleep 2
done

echo "Waiting for SSSD to find LDAP..."
SECONDS=0
until docker logs test_sssd_1 2>&1 | grep -q "Marking port 389 of server 'ldap' as 'working'"
do
  if (( SECONDS > 180 ))
  then
     echo "Giving up..."
     exit 1
  fi
  echo "SSSD has not found LDAP yet. Waiting..."
  sleep 10
done

sleep 1

function exec_in_borg_container() {
  docker exec -e 'BORG_REPO=billy@borg:backup' -e 'BORG_PASSPHRASE=test-passphrase' -e 'BORG_RSH=ssh -i /ssh_keys/id_ed25519 -o "StrictHostKeyChecking no"' test_borg-client_1 "$@"
}

echo "Test: Init borg repo"
exec_in_borg_container borg init --append-only --encryption=repokey-blake2

echo "Test: Create backup"
exec_in_borg_container bash -c 'mkdir -p /root/important-files && echo important-text > /root/important-files/important-document.txt'
exec_in_borg_container borg create --stats ::FIRST /root/important-files

echo "Test: List backups"
exec_in_borg_container borg list | grep -q FIRST

echo "TESTS PASSWD"
