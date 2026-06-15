#!/usr/bin/env bash

set -e

cd "$(dirname "$0")" || exit 1
rm -rf ./build
mkdir ./build
./.venv/bin/python ./scripts/build_lab7.py
mariadb -u lab7_user < ./sql/main.sql

rm -rf ./submission
mkdir ./submission
# This syntax emulates tee command usage without
# explicitly entering the db, making this much faster
# to replicate. I know it is technically not in the
# instructions but I figure it may be okay as a user
# could run the scripts like normal with the tee command.
mariadb -u lab7_user -t lab7 \
    < ./sql/queries.sql \
    > ./submission/outputQuery.txt

mariadb -u lab7_user -t lab7 \
    < ./sql/activity.sql \
    > ./submission/outputActivity.txt

cp ./build/populateData.sql ./submission/
cp ./sql/createLibrary.sql ./sql/activity.sql ./sql/queries.sql ./submission/
cp README.txt ./submission/

echo "Lab ran successfully"