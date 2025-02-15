#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}Adding repositories ...${RESET}"
dnf autoremove -y
dnf copr enable peterwu/rendezvous -y
dnf copr enable pgdev/ghostty -y
dnf copr enable zeno/scrcpy -y
dnf update --refresh -y
echo -e "${GREEN}All repositories added ...${RESET}"
echo "${GREEN}Installing packages ...${RESET}"

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
	goverlay
	ghostty
	gstreamer1-plugin-openh264
	jetbrains-mono-fonts-all
	mangohud
	memtest86+
	mc
	mesa-va-drivers-freeworld
	mesa-vdpau-drivers-freeworld
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
echo -e "${GREEN}Swapping VGA drivers ...${RESET}"

dnf swap mesa-va-drivers mesa-va-drivers-freeworld
swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld