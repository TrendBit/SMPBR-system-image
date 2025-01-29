#!/bin/bash

# Instal system service files (cannot be install into system during configuration)
sudo mv /home/reactor/can0.service /etc/systemd/system/
sudo mv /home/reactor/bioreactor.service /etc/avahi/services/

sudo chmod 644 /etc/avahi/services/bioreactor.service

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service so it starts on boot
sudo systemctl enable can0.service
sudo systemctl start can0.service

# Enable avahi service (for mDNS)
sudo systemctl enable avahi-daemon
sudo systemctl start avahi-daemon

# Core module
cd /home/reactor/core-module/build
sudo make install-service
sudo systemctl enable core-module
sudo systemctl start core-module

# API server
cd /home/reactor/api-server/build
sudo make install-service
sudo systemctl enable api-server
sudo systemctl start api-server

# Recipe runner
cd /home/reactor/recipe-runner/build
sudo make install-service

# Add env variables related to device SID and location of target database (mDNS of smpbr_data.local)
echo 'export SMPBR_SID=$(core-module --sid)' | sudo tee -a /etc/profile > /dev/null
echo 'export DATABASE_ADDRESS=$(avahi-resolve-host-name -4 smpbr_data.local | cut -f2)' | sudo tee -a /etc/profile > /dev/null
source /etc/profile

# Telegraf
sudo systemctl enable telegraf.service
sudo systemctl start telegraf.service

# Clean up build logs
sudo chown -R reactor:reactor /home/reactor/
sudo rm -rf /home/reactor/*.out
sudo rm -rf /home/reactor/*.error

