#!/bin/bash

# Parse arguments
RESET=false

usage() {
    echo "Usage: $0 [-r|--reset]"
    echo "Options:"
    echo "  -r, --reset    Reset local repository changes and clean untracked files"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--reset)
            RESET=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown parameter: $1"
            usage
            ;;
    esac
done

reset_repo() {
    if [ "$RESET" = true ]; then
        git reset --hard
        git clean -fd
    fi
}

sudo systemctl stop api-server
sudo systemctl stop core-module
sudo systemctl stop telegraf
RECIPE_RUNNER_ACTIVE=$(sudo systemctl is-active recipe-runner)
sudo systemctl stop recipe-runner

cd /home/reactor/api-server
reset_repo
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/core-module
reset_repo
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/recipe-runner
reset_repo
git pull
cd build
cmake ..
make
sudo make install
sudo make install-service

cd /home/reactor/database-export
reset_repo
git pull
sudo cp /home/reactor/database-export/telegraf.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl start api-server
sudo systemctl start core-module
sudo systemctl start telegraf
if [ "$RECIPE_RUNNER_ACTIVE" = "active" ]; then
    sudo systemctl start recipe-runner
fi
