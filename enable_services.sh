#!/bin/bash

# Instal system service files (cannot be install into system during configuration)
sudo cp /home/reactor/can0.service /etc/systemd/system/
sudo cp /home/reactor/bioreactor.service /etc/avahi/services/

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
cd /home/reactor/SMBR-can-core-module/build
sudo make install-service
sudo systemctl enable core-module
sudo systemctl start core-module

# API server
cd /home/reactor/SMBR-api-server/build
sudo make install-service
sudo systemctl enable api-server
sudo systemctl start api-server

# Recipe runner
cd /home/reactor/SMBR-recipe-runner/build
sudo make install-service
