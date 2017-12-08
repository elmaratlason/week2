#!/bin/bash
# runs docker host, starts both postgres database and application
# Háskólinn í Reykjavík - 2017
# elmar.atlason@gmail.com / elmar14@ru.is

set -e

sleep 10
npm run migratedb
node run.js

exit 0
