#!/bin/bash
sudo systemctl stop api-server
sudo systemctl stop core-module
RECIPE_RUNNER_ACTIVE=$(systemctl is-active recipe-runner)
sudo systemctl stop recipe-runner

cd /home/reactor/SMBR-api-server
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/SMBR-can-core-module
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/SMPBR-recipe-runner
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

sudo systemctl daemon-reload

sudo systemctl start api-server
sudo systemctl start core-module
if [ "$RECIPE_RUNNER_ACTIVE" = "active" ]; then
    sudo systemctl start recipe-runner
fi
