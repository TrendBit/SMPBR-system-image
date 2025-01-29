#!/bin/bash

# Fetch the latest release URL
url=$(curl -s https://api.github.com/repos/TrendBit/SMBR-firmware/releases/latest | grep "browser_download_url.*\.zip" | cut -d '"' -f 4)

# Define the firmware directory
firmware_dir="./firmware"

if [ -n "$url" ]; then
    echo "Downloading from: $url"

    # Ensure the firmware directory exists
    mkdir -p "$firmware_dir"

    # Download the archive
    archive_name="$(basename "$url")"
    curl -L -o "$firmware_dir/$archive_name" "$url"

    # Unzip the archive into the firmware directory
    unzip -o "$firmware_dir/$archive_name" -d "$firmware_dir"

    echo "Firmware unzipped to $firmware_dir"

    # Install the firmware
    echo "Installing firmware..."

    cd $firmware_dir
    echo "Y" | python3 update_all_modules.py -d binaries

else
    echo "Error: Could not fetch the download URL."
    exit 1
fi
