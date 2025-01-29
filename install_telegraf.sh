cd /home/reactor
sudo dpkg -i telegraf.deb
rm telegraf.deb
sudo cp /home/reactor/database-export/telegraf.service /etc/systemd/system/
