#!/bin/bash
sudo systemctl stop api-server
sudo systemctl stop core-module
sudo systemctl stop telegraf
RECIPE_RUNNER_ACTIVE=$(systemctl is-active recipe-runner)
sudo systemctl stop recipe-runner

cd /home/reactor/api-server
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/core-module
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/recipe-runner
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/database-export
git pull
sudo cp /home/reactor/database-export/telegraf.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl start api-server
sudo systemctl start core-module
sudo systemctl start telegraf
if [ "$RECIPE_RUNNER_ACTIVE" = "active" ]; then
    sudo systemctl start recipe-runner
fi
