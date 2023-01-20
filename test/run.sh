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

