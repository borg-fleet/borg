#!/bin/bash
set -e

ssh-keygen -A

exec "$@"