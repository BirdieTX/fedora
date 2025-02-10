#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}ERROR: Not running as root or sudo ...${RESET}"
    exit 1
fi

chmod +x remove-packages.sh
chmod +x install-packages.sh
chmod +x install-flatpaks.sh
cp -r dnf.conf /etc/dnf
cp -r fastfetch /home/birdie/.config
cp -r fish /home/birdie/.config
cp -r ghostty /home/birdie/.config
cp -r user-dirs.dirs /home/birdie/.config
./remove-packages.sh
./install-packages.sh
./install-flatpaks.sh
cd /home/birdie/.local/share
git clone https://github.com/svenstaro/genact.git
cd /home/birdie/Downloads
git clone --depth 1 gitlab.com/VandalByte/darkmatter-grub-theme.git
cd darkmatter-grub-theme
python3 darkmatter-theme.py --install
hostnamectl set-hostname Fedora