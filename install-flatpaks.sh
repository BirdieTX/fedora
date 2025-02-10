#!/bin/bash

# Script to automatically install packages on Arch Linux
# Usage: ./install-packages.sh

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}Installing flatpaks ...${RESET}"
flatpak update -y

# List of packages to install
PACKAGES=(
	org.audacityteam.Audacity
	com.usebottles.bottles
	com.brave.Browser
	org.gnome.Characters
	nl.hjdskes.gcolor3
	org.gnome.Connections
	com.bitwarden.desktop
	ca.desrt.dconf-editor
	org.gnome.Decibels
	io.github.freedoom.Phase1
	io.github.endless_sky.endless_sky
	org.gnome.Evince
	org.gnome.Extensions
	com.github.tchx84.Flatseal
	com.geeks3d.furmark
	io.github.realmazharhussain.GdmSettings
	org.gimp.GIMP
	io.github.shiftey.Desktop
	org.kde.kdenlive
	org.gnome.Logs
	org.gnome.Loupe
	net.lutris.Lutris
	org.fedoraproject.MediaWriter
	com.obsproject.Studio
	md.obsidian.Obsidian
	org.onlyoffice.desktopeditors
	org.openttd.OpenTTD
	com.pokemmo.PokeMMO
	me.proton.Mail
	com.protonvpn.www
	net.davidotek.pupgui2
	com.github.Matoking.protontricks
	io.github.Qalculate
	net.runelite.RuneLite
	org.signal.Signal
	io.github.pwr_solaar.solaar
	com.valvesoftware.Steam
	com.valvesoftware.Steam.Utility.steamtinkerlaunch
	org.gnome.Totem
	com.vscodium.codium
	io.github.aandrew_me.ytdn
)

echo -e "${GREEN}Installing flatpaks ...${RESET}"
for PACKAGE in "${PACKAGES[@]}"; do
    if flatpak install flathub "$PACKAGE" -y; then
        echo -e "${GREEN}$PACKAGE installed successfully.${RESET}"
    else
        echo -e "${RED}Failed to install $PACKAGE.${RESET}"
    fi
done
echo -e "${GREEN}All flatpaks installed successfully...${RESET}"
