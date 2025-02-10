#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}Adding repositories ...${RESET}"
sudo dnf autoremove -y
sudo dnf copr enable peterwu/rendezvous -y
sudo dnf copr enable pgdev/ghostty -y
sudo dnf copr enable tomaszgasior/mushrooms -y
sudo dnf copr enable zeno/scrcpy -y
sudo dnf update --refresh -y
echo "All repositories added ..."
echo "Installing packages ..."

PACKAGES=(
	"https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
	"https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
	bibata-cursor-themes
	bat
	cargo
	cmatrix
	discord
	eza
	fastfetch
	fish
	gamescope
	gnome-tweaks
	goverlay
	ghostty
	grub-customizer
	gstreamer1-plugin-openh264
	jetbrains-mono-fonts-all
	kernel-longterm
	mangohud
	memtest86+
	mc
	mesa-freeworld
	mozilla-openh264
	nautilus-admin
	papirus-icon-theme
	protontricks
	pulseaudio-utils
	scrcpy
	steam-devices
	terminus-fonts
)

echo -e "${GREEN}Installing packages ...${RESET}"
for PACKAGE in "${PACKAGES[@]}"; do
    if sudo dnf install "$PACKAGE" -y; then
        echo -e "${GREEN}$PACKAGE installed successfully.${RESET}"
    else
        echo -e "${RED}Failed to install $PACKAGE.${RESET}"
    fi
done
echo -e "${GREEN}All packages installed successfully ...${RESET}"
