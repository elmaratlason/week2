#!/bin/bash

sudo npm install -g nodemon
sudo npm install -g create-react-app
sudo npm run startpostgres && sleep 10 && npm run migratedb
npm install

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

