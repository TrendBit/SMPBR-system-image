#!/bin/bash

# Instal system service files (cannot be install into system during configuration)
sudo mv /home/reactor/can0.service /etc/systemd/system/
sudo mv /home/reactor/bioreactor.service /etc/avahi/services/

sudo chmod 666 /etc/avahi/services/bioreactor.service

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

# Telegraf
sudo touch /etc/telegraf/telegraf.env
sudo systemctl enable telegraf.service
sudo systemctl start telegraf.service

# Clean up build logs
sudo chown -R reactor:reactor /home/reactor/
sudo rm -rf /home/reactor/*.out
sudo rm -rf /home/reactor/*.error

