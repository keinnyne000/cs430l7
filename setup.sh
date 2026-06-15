#!/usr/bin/env bash

set -e

cd "$(dirname "$0")" || exit 1

./setup/setup_venv.sh

sudo mariadb < ./setup/setup_user.sql