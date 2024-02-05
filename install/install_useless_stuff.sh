#!/bin/sh

cd ~/build

# rofi-emoji
git clone https://github.com/Mange/rofi-emoji.git
sudo apt-get update
sudo apt-get install -y rofi-dev autoconf automake libtool-bin libtool
autoreconf -i
mkdir build
cd build/
../configure
make
sudo make install
libtool --finish /usr/lib/x86_64-linux-gnu/rofi/
#

cd ~/build
