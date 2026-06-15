#!/usr/bin/env bash

set -e

cd "$(dirname "$0$")/.." || exit 1

rm -rf .venv
python3 -m venv .venv
./.venv/bin/python -m pip install --upgrade pip
./.venv/bin/python -m pip install -r requirements.txt