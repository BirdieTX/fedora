#!/bin/bash

sudo cp -r dnf.conf /etc/dnf
cp -r fastfetch /home/birdie/.config
cp -r fish /home/birdie/.config
cp -r ghostty /home/birdie/.config
cp -r user-dirs.dirs /home/birdie/.config
./remove-packages.sh
./install-packages.sh
./install-flatpaks.sh
cd /home/birdie/.local/share
git clone https://github.com/svenstaro/genact.git