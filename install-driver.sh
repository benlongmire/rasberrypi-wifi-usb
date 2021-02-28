#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# Dependencies
sudo apt update
sudo apt install git bc bison flex libssl-dev
sudo wget https://raw.githubusercontent.com/RPi-Distro/rpi-source/master/rpi-source -O /usr/local/bin/rpi-source && sudo chmod +x /usr/local/bin/rpi-source && /usr/local/bin/rpi-source -q --tag-update
sudo rpi-source

# Download and compile driver
git clone "https://github.com/gnab/rtl8812au"
cd rtl8812au
sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
sed -i 's/CONFIG_PLATFORM_ARM_RPI = n/CONFIG_PLATFORM_ARM_RPI = y/g' Makefile
sudo make

# Copy driver and install
sudo cp 8812au.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless
sudo depmod -a
sudo modprobe 8812au

echo "Done!"