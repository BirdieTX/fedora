#!/bin/bash

set -e

END='\033[0m\n'
RED='\033[0;31m'

sudo dnf config-manager setopt brave-browser.enabled=1
sudo dnf config-manager setopt code.enabled=1
sudo dnf copr enable kylegospo/grub-btrfs -y || printf $RED"Failed to enable grub-btrfs copr repository"$END && sleep 2
sudo dnf copr enable herzen/davinci-helper -y || printf $RED"Failed to enable davinci-helper copr repository"$END && sleep 2
sudo dnf upgrade --refresh || printf $RED"Did not update rpm packages ..."$END && sleep 2
sudo dnf config-manager setopt brave-browser.enabled=0
sudo dnf config-manager setopt code.enabled=0
sudo dnf copr disable kylegospo/grub-btrfs
sudo dnf copr disable herzen/davinci-helper
flatpak update
fastfetch -c examples/10
