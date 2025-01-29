# SMPBR-system-image  
Custom image for RaspberryPi 4 based on RPiOs-Lite customized with sdm-tool. Contains application required to run bioreactor.  

# Image preparation
Base image is RPiOS Lite 64-bit Bookworm from 19.11.2024 and must be update manualy.
Makefile is used as wrapper for action to customize and flash image.
Commands must be executed with `sudo` (there is also docker alternative).
Target:
    - `image` - perform customization based on `plugin` and `apps` files
    - `explore` - enter image via `chroot`
    - `burn DEVICE=sdX` - copy image data onto selected device
    - `mass_burn DEVICE=sdX` - perform burn in loop customizable by `flash_file.data`
  

# First boot  
First boot can take several minutes and is composed of two boot operations.  
After first boot device will perform system customization and restart.  
After second boot, device can be used by user.  

# Access  
User: `reactor` Password: `grow`  
IP address should be obtained from local DHCP server.  
SSH server is enabled on port 22 and supports password authentication.  

# Identification  
On device is running avahi-deamon providing mDNS. Which can be used to discover services in local network.  
Devices can be then discovered by executing `avahi-browse -art` and in output record for SMPBR bioreactors should look like:  
```  
= enp5s0 IPv4 BioReactor                                     _bioreactor_api._tcp local  
   hostname = [smpbr-01.local]  
   address = [192.168.1.242]  
   port = [8089]  
   txt = ["description=SMPBR Control API" "type=rest" "version=1.0" "path=/swagger/ui"]  
```  
This record contains pointer to API server for control of the device.  
Also provides local hostname which can be used as ssh host: `ssh reactor@smpbr-01`.  
And API should be accessible in browser at: `smpbr-01:8089` or `192.168.1.242:8089`  
Also Swagger UI is opened on `smpbr-01:8089/swagger/ui` or `192.168.1.242:8089/swagger/ui`  

## Fleet management  
When there is more devices in one network, there could be more suitable to use fleet management tool  
Which can also discover devices and more.  
```  
$> fleet.py discover
smpbr-01 192.168.1.242  
```  
